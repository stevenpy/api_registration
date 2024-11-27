require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do
  describe 'POST /api/v1/signup' do
    before(:each) do
      AvailablePseudo.delete_all
    end

    context 'when pseudo is available' do
      before do
        AvailablePseudo.create!(pseudo: 'ABC')
      end

      it 'creates a new user with the requested pseudo' do
        post '/api/v1/signup', params: { user: { pseudo: 'ABC' } }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['pseudo']).to eq('ABC')
        expect(json_response['message']).to eq('User created successfully')
        expect(User.find_by(pseudo: 'ABC')).to be_present
      end

      it 'creates a new user with any available pseudo when none specified' do
        post '/api/v1/signup', params: { user: { pseudo: nil } }

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['pseudo']).to match(/^[A-Z]{3}$/)
        expect(json_response['message']).to eq('User created successfully')
      end
    end

    context 'when no pseudos are available' do
      it 'returns an error' do
        post '/api/v1/signup', params: { user: { pseudo: 'ABC' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('No more pseudos available')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error when parameters are missing' do
        post '/api/v1/signup'

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('param is missing or the value is empty: user')
      end

      it 'returns an error when user parameter is empty' do
        post '/api/v1/signup', params: { user: {} }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('param is missing or the value is empty: user')
      end
    end
  end
end
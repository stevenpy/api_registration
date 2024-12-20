require 'rails_helper'

RSpec.describe UserRegistrationService do
  before(:each) do
    AvailablePseudo.delete_all
    User.delete_all
  end

  describe '#call' do
    context 'when pseudos are available' do
      before do
        AvailablePseudo.create!(pseudo: 'ABC')
        AvailablePseudo.create!(pseudo: 'XYZ')
      end

      it 'creates a user with the requested pseudo if available' do
        service = UserRegistrationService.new('ABC')
        result = service.call

        expect(result[:success]).to be true
        expect(result[:pseudo]).to eq('ABC')
        expect(User.find_by(pseudo: 'ABC')).to be_present
        expect(AvailablePseudo.find_by(pseudo: 'ABC')).to be_nil
      end

      it 'creates a user with any available pseudo if none specified' do
        service = UserRegistrationService.new(nil)
        result = service.call

        expect(result[:success]).to be true
        expect(result[:pseudo]).to match(/^[A-Z]{3}$/)
        expect(User.find_by(pseudo: result[:pseudo])).to be_present
      end
    end

    context 'when no pseudos are available' do
      it 'returns an error' do
        service = UserRegistrationService.new('ABC')
        result = service.call

        expect(result[:success]).to be false
        expect(result[:error]).to eq('No more pseudos available')
      end
    end
  end
end
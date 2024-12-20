require 'rails_helper'

RSpec.describe AvailablePseudo, type: :model do
  describe '.give_pseudo' do
    before(:each) do
      AvailablePseudo.delete_all
    end

    context 'when specific pseudo is requested' do
      it 'returns and removes the requested pseudo if available' do
        AvailablePseudo.create!(pseudo: 'ABC')
        AvailablePseudo.create!(pseudo: 'XYZ')

        result = AvailablePseudo.give_pseudo('ABC')

        expect(result).to eq('ABC')
        expect(AvailablePseudo.find_by(pseudo: 'ABC')).to be_nil
        expect(AvailablePseudo.count).to eq(1)
      end
    end

    context 'when no specific pseudo is requested' do
      it 'returns and removes the first available pseudo' do
        AvailablePseudo.create!(pseudo: 'ABC')
        AvailablePseudo.create!(pseudo: 'XYZ')

        result = AvailablePseudo.give_pseudo(nil)

        expect(result).to match(/^[A-Z]{3}$/)
        expect(AvailablePseudo.count).to eq(1)
      end
    end

    context 'when no pseudos are available' do
      it 'raises an error' do
        expect {
          AvailablePseudo.give_pseudo('ABC')
        }.to raise_error(StandardError, 'No more pseudos available')
      end
    end

    context 'when requested pseudo is not available' do
      it 'returns the first available pseudo instead' do
        AvailablePseudo.create!(pseudo: 'XYZ')

        result = AvailablePseudo.give_pseudo('ABC')

        expect(result).to eq('XYZ')
        expect(AvailablePseudo.count).to eq(0)
      end
    end
  end
end
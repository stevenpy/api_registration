require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    AvailablePseudo.delete_all
    User.delete_all
  end

  describe 'validations' do
    it 'is valid with a valid pseudo' do
      user = User.new(pseudo: 'ABC')
      expect(user).to be_valid
    end

    it 'is invalid without a pseudo' do
      user = User.new(pseudo: nil)
      expect(user).not_to be_valid
      expect(user.errors[:pseudo]).to include("can't be blank")
    end

    it 'is invalid with a pseudo not matching format' do
      invalid_pseudos = ['abc', 'AB', 'ABCD', '123', 'AB1']

      invalid_pseudos.each do |pseudo|
        user = User.new(pseudo: pseudo)
        expect(user).not_to be_valid
        expect(user.errors[:pseudo]).to include("must be 3 capital letters")
      end
    end

    it 'enforces uniqueness of pseudo' do
      User.create!(pseudo: 'ABC')
      duplicate_user = User.new(pseudo: 'ABC')

      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:pseudo]).to include("has already been taken")
    end
  end

  describe 'callbacks' do
    it 'recreates available pseudo after destruction' do

      available_pseudo = AvailablePseudo.create!(pseudo: 'XYZ')

      user = UserRegistrationService.new('XYZ').call
      expect(user[:success]).to be true

      expect(AvailablePseudo.find_by(pseudo: 'XYZ')).to be_nil

      User.find_by(pseudo: 'XYZ').destroy

      recreated_pseudo = AvailablePseudo.find_by(pseudo: 'XYZ')
      expect(recreated_pseudo).to be_present
      expect(recreated_pseudo.pseudo).to eq('XYZ')
    end
  end
end
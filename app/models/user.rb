class User < ApplicationRecord
  after_destroy :recreate_available_pseudo

  validates :pseudo, presence: true,
                    format: { with: /\A[A-Z]{3}\z/, message: "must be 3 capital letters" },
                    uniqueness: true

  private

  def recreate_available_pseudo
    AvailablePseudo.create!(pseudo: pseudo)
  end
end
class User < ApplicationRecord
  validates :pseudo, presence: true,
                    format: { with: /\A[A-Z]{3}\z/, message: "must be 3 capital letters" },
                    uniqueness: true
end
class AvailablePseudo < ApplicationRecord
  def self.give_pseudo(pseudo)
    transaction do
      pseudo_record = AvailablePseudo.find_by(pseudo: pseudo) || AvailablePseudo.first
      raise StandardError, "No more pseudos available" unless pseudo_record

      available_pseudo = pseudo_record.pseudo
      pseudo_record.destroy!
      available_pseudo
    end
  end
end
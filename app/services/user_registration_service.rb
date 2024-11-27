class UserRegistrationService
  def initialize(pseudo)
    @pseudo = pseudo
  end

  def call
    pseudo = nil

    ActiveRecord::Base.transaction do
      pseudo = AvailablePseudo.give_pseudo(@pseudo)
      User.create!(pseudo: pseudo)
    end

    { success: true, pseudo: pseudo, message: 'User created successfully' }
  rescue StandardError => e
    if e.message.include?("No more pseudos available")
      { success: false, error: "No more pseudos available" }
    else
      { success: false, error: e.message }
    end
  end
end
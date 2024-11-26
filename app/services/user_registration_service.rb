class UserRegistrationService
  attr_reader :pseudo

  def initialize(pseudo)
    @pseudo = pseudo
  end

  def call
    user = User.new(pseudo: pseudo)

    if user.save
      { success: true, pseudo: user.pseudo, message: 'User created successfully' }
    else
      new_pseudo = generate_available_pseudo
      user = User.create!(pseudo: new_pseudo)

      { success: true, pseudo: user.pseudo, message: 'Requested pseudo was taken, generated new pseudo' }
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.message}
  end

  private

  def generate_available_pseudo
    letters = ('A'..'Z').to_a
    loop do
      pseudo = 3.times.map { letters.sample }.join
      return pseudo unless User.exists?(pseudo: pseudo)
    end
  end
end
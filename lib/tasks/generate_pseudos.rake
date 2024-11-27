namespace :pseudo do
  desc "Generate all possible 3-letter pseudos"
  task generate: :environment do
    letters = ('A'..'Z').to_a
    combinations = letters.repeated_permutation(3).map(&:join).shuffle

    AvailablePseudo.delete_all

    combinations.each_slice(1000) do |batch|
      records = batch.map do |pseudo|
        {
          pseudo: pseudo,
          created_at: Time.current,
          updated_at: Time.current
        }
      end
      AvailablePseudo.insert_all(records)
    end

    puts "Generated #{combinations.size} pseudos."
  end
end
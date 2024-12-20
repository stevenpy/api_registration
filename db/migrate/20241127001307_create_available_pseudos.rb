class CreateAvailablePseudos < ActiveRecord::Migration[7.1]
  def change
    create_table :available_pseudos do |t|
      t.string :pseudo, null: false

      t.timestamps
    end
    add_index :available_pseudos, :pseudo, unique: true
  end
end
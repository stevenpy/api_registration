class CreateAvailablePseudos < ActiveRecord::Migration[7.1]
  def change
    create_table :available_pseudos do |t|
      t.string :pseudo

      t.timestamps
    end
    add_index :available_pseudos, :pseudo
  end
end
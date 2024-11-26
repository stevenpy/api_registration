class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :pseudo, null: false, limit: 3
      t.timestamps
    end

    add_index :users, :pseudo, unique: true
  end
end
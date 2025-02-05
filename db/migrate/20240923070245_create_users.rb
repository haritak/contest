class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username, limit: 100

      t.timestamps
    end
    add_index :users, :email
    add_index :users, :username, unique: true
  end
end

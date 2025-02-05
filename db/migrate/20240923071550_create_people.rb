class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :last_name
      t.string :first_name
      t.string :father_name
      t.string :mother_name
      t.integer :gender
      t.string :contact_phone
      t.string :contact_email

      t.timestamps
    end
  end
end

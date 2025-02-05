class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :school_type
      t.string :contact_phone
      t.string :contact_email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :schools, :name, unique: true
  end
end

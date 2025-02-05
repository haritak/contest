class CreateSpecialities < ActiveRecord::Migration[7.1]
  def change
    create_table :specialities do |t|
      t.string :code, limit: 30
      t.string :description, limit: 200

      t.timestamps
    end
    add_index :specialities, :code, unique: true
  end
end

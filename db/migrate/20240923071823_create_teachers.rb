class CreateTeachers < ActiveRecord::Migration[7.1]
  def change
    create_table :teachers do |t|
      t.references :person, null: false, foreign_key: true
      t.references :speciality, null: false, foreign_key: true
      t.integer :team_role

      t.timestamps
    end
  end
end

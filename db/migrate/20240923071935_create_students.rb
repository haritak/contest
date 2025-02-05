class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.references :person, null: false, foreign_key: true
      t.string :taksi

      t.timestamps
    end
  end
end

class CreateStudentSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :student_submissions do |t|
      t.references :student, null: false, foreign_key: true
      t.references :student_submission_type, null: false, foreign_key: true
      t.string :title
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.boolean :finalized, default: false
      t.datetime :finalized_date

      t.timestamps
    end
  end
end

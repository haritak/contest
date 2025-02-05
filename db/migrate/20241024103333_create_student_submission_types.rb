class CreateStudentSubmissionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :student_submission_types do |t|
      t.string :name
      t.text :description
      t.string :accepted_filetype
      t.integer :max_submissions
      t.boolean :optional

      t.timestamps
    end
  end
end

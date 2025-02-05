class CreateStudentSubmissionUserTags < ActiveRecord::Migration[7.1]
  def change
    create_table :student_submission_user_tags do |t|
      t.references :student_submission, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddStudentSubmissionToInvitedSubmission < ActiveRecord::Migration[7.1]
  def change
    add_reference :invited_submissions, :student_submission, null: true, foreign_key: true
    change_column_null :invited_submissions, :submission_id, true
  end
end

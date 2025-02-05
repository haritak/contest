class AddReviewStaffToStudentSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :student_submissions, :review_user_id, :bigint
    add_column :student_submissions, :review_datetime, :datetime
    add_column :student_submissions, :review_notes, :text
    add_column :student_submissions, :review_public, :boolean
    add_column :student_submissions, :review_marked_ok, :boolean, default: false

    add_foreign_key :student_submissions, :users, column: :review_user_id, null: true
  end
end

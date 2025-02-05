json.extract! student_submission, :id, :student_id, :student_submission_type_id, :file, :title, :notes, :user_id, :finalized, :finalized_date, :created_at, :updated_at
json.url student_submission_url(student_submission, format: :json)
json.file url_for(student_submission.file)

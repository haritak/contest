json.extract! student_submission_type, :id, :name, :description, :accepted_filetype, :max_submissions, :optional, :created_at, :updated_at
json.url student_submission_type_url(student_submission_type, format: :json)

json.extract! submission, :id, :submission_file, :submission_description, :user_id, :created_at, :updated_at
json.url submission_url(submission, format: :json)
json.submission_file url_for(submission.submission_file)

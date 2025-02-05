json.extract! invited_submission, :id, :submission_id, :invitation_id, :created_at, :updated_at
json.url invited_submission_url(invited_submission, format: :json)

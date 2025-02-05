json.extract! invitation, :id, :user_id, :student_id, :link, :active, :submission_type_id, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)

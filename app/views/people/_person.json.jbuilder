json.extract! person, :id, :last_name, :first_name, :father_name, :mother_name, :gender, :contact_phone, :contact_email, :created_at, :updated_at
json.url person_url(person, format: :json)

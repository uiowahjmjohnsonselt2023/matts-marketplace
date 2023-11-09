json.extract! user, :id, :first_name, :last_name, :city, :country, :password_digest, :username, :email, :created_at, :updated_at
json.url user_url(user, format: :json)

json.extract! invite, :id, :business_id, :recepient, :sender, :limit, :accepts, :status, :created_at, :updated_at
json.url invite_url(invite, format: :json)

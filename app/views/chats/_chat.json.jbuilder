json.extract! chat, :id, :summary, :active, :created_at, :updated_at
json.url chat_url(chat, format: :json)

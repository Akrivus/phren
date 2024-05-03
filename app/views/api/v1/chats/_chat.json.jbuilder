json.array! chat.messages do |message|
  json.content message.content
  json.role message.role

  json.audio_files message.audio_files do |audio_file|
    json.url rails_blob_url(audio_file)
  end

  json.created_at message.created_at
end
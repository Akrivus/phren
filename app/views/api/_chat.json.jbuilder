json.href api_path(@chat)

json.name @chat.prompt.name
json.description @chat.prompt.description
json.metadata @chat.prompt.metadata

json.model @chat.prompt.model
json.max_tokens @chat.prompt.max_tokens
json.temperature @chat.prompt.temperature
json.voice @chat.prompt.voice

json.interstitial_prompt @chat.prompt.interstitial_prompt

json.messages do
  json.array! @chat.messages do |message|
    json.content message.content
    json.role message.role

    json.audio_files message.audio_files do |audio_file|
      json.url rails_blob_url(audio_file)
    end if message.audio_files.attached?

    json.created_at message.created_at
  end
end

json.created_at @chat.created_at
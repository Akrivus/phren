json.api_url api_prompt_chat_url(@prompt, @chat)

json.metadata @prompt.metadata

json.model @prompt.model
json.max_tokens @prompt.max_tokens
json.temperature @prompt.temperature
json.voice @prompt.voice

json.messages do
  json.array! @chat.messages do |message|
    json.content message.content
    json.role message.role
  end
end

json.created_at @chat.created_at
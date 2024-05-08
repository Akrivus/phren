json.api_url api_prompt_chat_index_url(@prompt)
json.api_key @prompt.api_key

json.name @prompt.name
json.description @prompt.description
json.metadata @prompt.metadata

json.model @prompt.model
json.max_tokens @prompt.max_tokens
json.temperature @prompt.temperature
json.voice @prompt.voice

json.messages do
  json.array! @prompt.messages do |message|
    json.content message.content
    json.role message.role
  end
end

json.created_at @prompt.created_at
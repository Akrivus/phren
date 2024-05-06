json.href api_prompt_chat_index_url(@prompt)

json.name @prompt.name
json.metadata @prompt.metadata
json.api_key @prompt.api_key

json.avatar do
  json.url @prompt.avatar.url
end if @prompt.avatar.attached?

json.created_at @prompt.created_at
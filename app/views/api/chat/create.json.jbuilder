json.href api_prompt_chat_url(@prompt, @chat)

json.prompt @chat.messages.first.content
json.voice @chat.voice

json.created_at @chat.created_at
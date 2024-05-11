class AddChatToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :chat, foreign_key: true, type: :uuid
  end
end

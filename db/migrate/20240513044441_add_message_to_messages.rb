class AddMessageToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :message, foreign_key: true, type: :uuid
  end
end

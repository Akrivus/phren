class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :content
      t.string :role, default: 'user'

      t.references :chat, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

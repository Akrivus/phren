class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :content
      t.string :role, default: 'user'

      t.boolean :cloned, default: false

      t.references :chat, foreign_key: true, type: :uuid
      t.references :prompt, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

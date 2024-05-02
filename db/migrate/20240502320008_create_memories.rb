class CreateMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :memories, id: :uuid do |t|
      t.string :content
      t.references :friend, type: :uuid, null: false, foreign_key: true, type: :uuid
      t.references :chat, type: :uuid, null: false, foreign_key: true, type: :uuid
      t.references :document, type: :uuid, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

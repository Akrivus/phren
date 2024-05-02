class CreateMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :memories, id: :uuid do |t|
      t.string :content
      t.references :friend, null: false, foreign_key: true, type: :uuid
      t.references :chat, null: false, foreign_key: true, type: :uuid
      t.references :document, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

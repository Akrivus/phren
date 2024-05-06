class CreateMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :memories, id: :uuid do |t|
      t.string :context
      t.string :content

      t.references :prompt, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

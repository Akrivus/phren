class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts, id: :uuid do |t|
      t.string :name
      t.string :metadata
      t.string :api_key
      t.string :person_prompt, default: ''
      t.string :system_prompt, default: ''
      t.string :model, default: 'gpt-3.5-turbo'
      t.string :voice, default: 'alloy'
      t.integer :max_tokens
      t.float :temperature
      t.float :n
      t.float :top_p
      t.float :frequency_penalty
      t.float :presence_penalty
      t.boolean :organically_generates_memories, default: false

      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

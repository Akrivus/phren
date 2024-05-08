class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts, id: :uuid do |t|
      t.string :api_key
      t.string :name
      t.string :description
      t.string :metadata
      
      t.string :voice, default: 'alloy'

      t.string :model, default: 'gpt-3.5-turbo'
      t.integer :max_tokens
      t.float :temperature

      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

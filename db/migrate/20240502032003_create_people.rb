class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people, id: :uuid do |t|
      t.string :name
      t.string :person_prompt
      t.string :system_prompt
      t.string :model
      t.string :voice
      t.integer :max_tokens
      t.float :temperature
      t.float :n
      t.float :top_p
      t.float :frequency_penalty
      t.float :presence_penalty
      t.boolean :organically_generates_memories

      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

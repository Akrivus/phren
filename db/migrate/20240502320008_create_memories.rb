class CreateMemories < ActiveRecord::Migration[7.1]
  def change
    create_table :memories, id: :uuid do |t|
      t.string :content
      t.boolean :organic
      t.uuid :parent_id

      t.references :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

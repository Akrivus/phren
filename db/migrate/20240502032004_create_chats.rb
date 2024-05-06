class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats, id: :uuid do |t|
      t.string :voice

      t.references :prompt, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

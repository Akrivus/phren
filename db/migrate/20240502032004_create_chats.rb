class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats, id: :uuid do |t|
      t.string :prompt

      t.references :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

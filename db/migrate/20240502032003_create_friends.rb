class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends, id: :uuid do |t|
      t.string :name
      t.string :person_prompt
      t.string :system_prompt
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end

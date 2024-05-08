class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :password_digest

      t.string :api_key
      t.boolean :admin

      t.timestamps
    end
  end
end

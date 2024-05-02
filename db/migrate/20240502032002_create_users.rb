class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end
  end
end

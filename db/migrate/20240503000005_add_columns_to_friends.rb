class AddColumnsToFriends < ActiveRecord::Migration[7.1]
  def change
    add_column :friends, :model, :string
    add_column :friends, :voice, :string
  end
end

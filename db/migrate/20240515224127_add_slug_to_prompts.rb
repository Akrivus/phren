class AddSlugToPrompts < ActiveRecord::Migration[7.1]
  def change
    add_column :prompts, :slug, :string, null: false, default: 'untitled'
    add_index  :prompts, :slug,  unique: true
  end
end

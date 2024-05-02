class AddEmbeddings < ActiveRecord::Migration[7.0]
  def change
    add_column :memories, :embedding, :vector, dimensions: 1536
  end
end

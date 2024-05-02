class AddEmbeddings < ActiveRecord::Migration[7.0]
  def change
    add_column :memories, :embedding, :vector, dimensions: 1536
    add_index :memories, :embedding, using: :hnsw, opclass: :vector_l2_ops
  end
end

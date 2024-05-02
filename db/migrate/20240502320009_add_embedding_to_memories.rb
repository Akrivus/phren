class AddEmbeddingToMemories < ActiveRecord::Migration[7.1]
  def change
    add_column :memories, :embedding, :vector, dimension: 1536
    add_index :memories, :embedding, using: :ivfflat, opclass: :vector_l2_ops
  end
end

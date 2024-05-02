class AddEmbeddingToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :embedding, :vector, dimension: 1536
    add_index :messages, :embedding, using: :ivfflat, opclass: :vector_l2_ops
  end
end

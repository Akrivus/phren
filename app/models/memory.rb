class Memory < ApplicationRecord
  has_neighbors :embedding, dimensions: 1536
  
  belongs_to :person
  belongs_to :chat
end

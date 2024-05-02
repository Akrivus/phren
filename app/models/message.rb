class Message < ApplicationRecord
  has_neighbors :embedding, dimensions: 1536

  belongs_to :chat
  belongs_to :user, optional: true

  has_many_attached :audio_files
end

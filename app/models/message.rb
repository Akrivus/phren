class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user, optional: true

  has_many_attached :audio_files
end

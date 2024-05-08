class Message < ApplicationRecord
  belongs_to :chat, optional: true
  belongs_to :prompt, optional: true

  has_many_attached :audio_files

  validate do |message|
    orphaned = message.chat.nil? && message.prompt.nil?
    message.errors.add(:base, 'Message orphaned') if orphaned
  end
end

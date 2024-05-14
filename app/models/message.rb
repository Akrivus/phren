class Message < ApplicationRecord
  belongs_to :message, optional: true
  belongs_to :chat, optional: true
  belongs_to :prompt, optional: true

  has_many_attached :audio_files

  after_update :mirror_message, if: :content_changed?

  scope :in_order, -> { order(created_at: :asc) }

  validate do |message|
    orphaned = message.chat.nil? && message.prompt.nil?
    message.errors.add(:base, 'Message orphaned') if orphaned
  end

  def assistant?
    role == 'assistant'
  end

  def user?
    role == 'user'
  end

  def system?
    role == 'system'
  end

  def audio_files
    message ? message.audio_files : super
  end

  private

    def mirror_message
      message.update(content: content) if message
    end
end

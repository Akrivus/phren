class Chat < ApplicationRecord
  belongs_to :prompt
  belongs_to :chat, optional: true

  has_many :messages, dependent: :destroy, after_add: :mirror_message

  attr_accessor :context

  after_create :set_system_messages

  scope :in_order, -> { order(created_at: :desc) }

  def log_message content, role, file
    message = messages.create! content: content, role: role
    message.audio_files.attach(file) if file
  end

  def destroy_if_empty
    destroy unless messages.exists? cloned: false
  end

  handle_asynchronously :log_message
  handle_asynchronously :destroy_if_empty, run_at: 1.hour.from_now

  private

    def mirror_message message
      chat.messages.create(message: message, content: message.content, role: 'user', cloned: true) if chat && message.assistant?
    end

    def set_system_messages
      prompt.messages.in_order.each do |m|
        content = ERB.new(m.content).result_with_hash(context || {})
        message = messages.create! content: content, role: m.role, cloned: true
      end
    end
end

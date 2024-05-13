class Chat < ApplicationRecord
  belongs_to :prompt
  belongs_to :chat, optional: true

  has_many :messages, dependent: :destroy, after_add: :mirror_message

  attr_accessor :context

  after_create :set_system_messages

  def mirror_message message
    chat.messages.create(message: message, content: message.content, role: 'user', cloned: true) if chat && message.assistant?
  end

  private

    def set_system_messages
      prompt.messages.each do |message|
        content = ERB.new(message.content).result_with_hash(context || {})
        messages.create! content: content, role: message.role, cloned: true
      end
    end
end

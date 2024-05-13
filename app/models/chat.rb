class Chat < ApplicationRecord
  belongs_to :prompt
  belongs_to :chat, optional: true

  has_many :messages, dependent: :destroy, after_add: :mirror_message

  attr_accessor :context

  after_create :set_system_messages

  def mirror_message message
    chat.messages.create(message: message, content: message.content, role: 'user', cloned: true) if chat && message.assistant?
  end

  def destroy_if_empty
    destroy unless messages.exists? cloned: false
  end

  private

    def set_system_messages
      prompt.messages.each do |m|
        content = ERB.new(m.content).result_with_hash(context || {})
        message = messages.create! content: content, role: m.role, cloned: true
        message.delay(run_at: 1.hour.from_now).destroy_if_empty
      end
    end
end

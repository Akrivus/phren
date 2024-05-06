class Chat < ApplicationRecord
  belongs_to :prompt

  has_many :messages, dependent: :destroy

  after_create :add_system_message

  def add_system_message
    context = "You are chatting with #{chat.name}." if chat.name.present?
    content = [prompt.person_prompt, prompt.system_prompt, context].compact.join("\n\n")
    add_message content, 'system'
  end

  def add_message content, role = 'user'
    messages.create! content: content, role: role
  end

  def messages_to_map
    messages.order(:created_at).map do |message|
      { role: message.role, content: message.content }
    end
  end
end

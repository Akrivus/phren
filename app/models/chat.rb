class Chat < ApplicationRecord
  belongs_to :prompt

  has_many :messages, dependent: :destroy

  attr_accessor :context

  after_create :set_system_messages

  def set_system_messages
    prompt.messages.each do |message|
      content = ERB.new(message.content).result_with_hash(context || {})
      messages.create! content: content, role: message.role, cloned: true
    end
  end
end

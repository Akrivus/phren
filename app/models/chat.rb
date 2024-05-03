class Chat < ApplicationRecord
  belongs_to :person
  belongs_to :user

  has_many :messages, dependent: :destroy

  validates :prompt, presence: true

  after_create :add_system_message

  def add_system_message
    messages.create! content: prompt, role: 'system'
  end

  def add_message content, role = 'user'
    messages.create! content: content, role: role
  end

  def mapped_messages
    chat.messages.order(:created_at).map do |message|
      { role: message.role, content: message.content }
    end
  end
end

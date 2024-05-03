class Chat < ApplicationRecord
  belongs_to :person

  has_many :messages, dependent: :destroy

  validates :prompt, presence: true

  after_create :add_system_message

  def add_system_message
    messages.create! content: prompt, role: 'system'
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

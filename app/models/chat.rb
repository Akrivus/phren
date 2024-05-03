class Chat < ApplicationRecord
  belongs_to :person
  belongs_to :user

  has_many :messages, dependent: :destroy

  validates :prompt, presence: true

  after_create :add_system_message

  def add_system_message
    messages.create! content: prompt, role: 'system'
  end
end

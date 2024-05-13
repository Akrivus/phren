class Prompt < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages

  accepts_nested_attributes_for :messages, allow_destroy: true
end

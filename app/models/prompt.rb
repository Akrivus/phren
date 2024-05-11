class Prompt < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages
end

class Prompt < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages

  has_one_attached :avatar
end

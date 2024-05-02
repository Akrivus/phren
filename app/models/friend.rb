class Friend < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages, through: :chats

  has_one_attached :avatar
end

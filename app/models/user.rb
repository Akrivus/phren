class User < ApplicationRecord
  has_secure_password

  has_many :friends
  has_many :chats
  has_many :messages

  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true
end

class User < ApplicationRecord
  has_secure_password

  has_many :prompts, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true
end

class Prompt < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages

  accepts_nested_attributes_for :messages, allow_destroy: true

  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  private

  def generate_slug
    slug ||= name.parameterize + '-' + SecureRandom.hex(3)
  end
end

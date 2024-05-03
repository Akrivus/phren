class Person < ApplicationRecord
  belongs_to :user

  has_many :chats

  has_one_attached :avatar

  def prompt context = ""
    [person_prompt, system_prompt, context].join("\n\n").strip
  end

  def to_parameters messages
    parameters = { model: model, messages: messages }
    parameters[:max_tokens] = max_tokens if max_tokens.present?
    parameters[:temperature] = temperature if temperature.present?
    parameters[:n] = n if n.present?
    parameters[:top_p] = top_p if top_p.present?
    parameters[:frequency_penalty] = frequency_penalty if frequency_penalty.present?
    parameters[:presence_penalty] = presence_penalty if presence_penalty.present?
    parameters
  end
end

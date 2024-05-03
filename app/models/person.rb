class Person < ApplicationRecord
  belongs_to :user

  has_many :chats
  has_many :messages, through: :chats

  has_one_attached :avatar

  def prompt context = ""
    [person_prompt, system_prompt, context].join("\n\n").strip
  end

  def openai_parameters
    parameters = { model: model, messages: messages, stream: block }
    parameters[:max_tokens] = max_tokens if max_tokens.present?
    parameters[:temperature] = temperature if temperature.present?
    parameters[:n] = n if n.present?
    parameters[:top_p] = top_p if top_p.present?
    parameters[:frequency_penalty] = frequency_penalty if frequency_penalty.present?
    parameters[:presence_penalty] = presence_penalty if presence_penalty.present?
    parameters
  end
end

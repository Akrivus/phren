OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
end

module OpenAIClient
  extend ActiveSupport::Concern

  def tts text, voice
    openai_client.audio.speech(parameters: { model: 'tts-1', input: text, voice: voice, format: 'wav'})
  end

  def transcribe file, prompt = ""
    openai_client.audio.transcribe(parameters: { model: 'whisper-1', file: file, prompt: prompt })
  end

  def chat parameters
    parameters[:stream] = proc { |chunk, _size| yield chunk } if block_given?
    openai_client.chat(parameters: parameters)
  end

  def chat_tts message, parameters, voice
    fragment = ""
    openai_client.chat(parameters: parameters) do |chunk|
      token = chunk.dig('choices', 0, 'delta', 'content')
      fragment += token
      if %w[. ! ?].include?(token)
        yield tts(fragment, voice)
        fragment = ""
      end
    end
  end

  def openai_client
    @@openai_client ||= OpenAI::Client.new
  end
end
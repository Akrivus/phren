OpenAI.configure do |config|
  config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
end

module OpenAIClient
  extend ActiveSupport::Concern

  included do
    def transcribe file, prompt = "", message = nil
      resp = openai_client.audio.transcribe(parameters: { model: 'whisper-1', file: file, prompt: prompt })
      text = resp.dig('text')

      if message.present?
        message.content = text
        message.audio_files.attach(file)
      end

      return text
    end

    def tts text, voice, message = nil
      data = openai_client.audio.speech(parameters: { model: 'tts-1', input: text, voice: voice, format: 'wav'})
      file = StringIO.new(data)

      if message.present?
        filename = "speech-#{message.audio_files.count}.wav"
        message.audio_files.attach(io: file, filename: filename, content_type: 'audio/wav')
        file = message.audio_files.last
      end

      return file
    end

    def chat parameters, message = nil, stops = ".!?"
      fragment = ""
      parameters[:stream] = proc do |chunk, _size|
        token = chunk.dig('choices', 0, 'delta', 'content')
        fragment += token
        next if token.blank?
        if stops.include? token
          yield fragment
          fragment = ""
        end
      end if block_given?

      resp = openai_client.chat(parameters: parameters)
      text = resp if parameters[:stream]
      text = resp.dig('choices', 0, 'message', 'content') unless parameters[:stream]

      message.content = text if message.present?

      return text
    rescue => e
      puts e.inspect
    end

    def chat_tts parameters, voice, message = nil, stops = ".!?"
      if block_given?
        chat(parameters, message, stops) do |fragment|
          yield fragment, tts(fragment, voice, message)
        end
      else
        text = chat(parameters, message, stops)
        audio = tts(text, voice, message)
        return text, audio
      end
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
  end
end
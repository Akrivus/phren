require 'sinatra/base'

class ProxyController < Sinatra::Base
  post '/audio/speech' do
    content_type get_mime_type_for(speech_params[:response_format])
    openai_client.audio.speech(parameters: speech_params)
  rescue Faraday::ClientError => e
    halt e.response[:status], to_json(e.response[:body])
  end

  post '/audio/transcriptions' do
    to_json(openai_client.audio.transcribe(parameters: transcription_params))
  rescue Faraday::ClientError => e
    halt e.response[:status], to_json(e.response[:body])
  end

  post '/chat/completions' do
    content_type 'text/event-stream'
    stream do |sse|
      params[:stream] = proc { |data| sse << "data: #{Oj.dump(data)}\n\n" }
      openai_client.chat(parameters: chat_params)
      sse << "data: [[DONE]]\n\n"
    end if params[:stream]
    unless params[:stream]
      to_json(openai_client.chat(parameters: chat_params))
    end
  rescue Faraday::ClientError => e
    halt e.response[:status], to_json(e.response[:body])
  end

  post '/embeddings' do
    to_json(openai_client.embeddings(parameters: embedding_params))
  rescue Faraday::ClientError => e
    halt e.response[:status], to_json(e.response[:body])
  end
  
  before do
    pass if request.env['CONTENT_TYPE'] != 'application/json'
    request.body.rewind
    json = Oj.load(request.body.read)
    json.each { |k, v| params[k] = v }
  end

  private
    def check_access_token
      token = JWT.decode(request.env['HTTP_AUTHORIZATION'][7..-1], ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256')
      token[1]
    rescue JWT::DecodeError => e
      halt 403, to_json({ "error" => e.message })
    end

    def speech_params
      params[:user] = check_access_token[:uid]
      params.slice(:model, :voice, :input, :response_format, :user)
    end

    def transcription_params
      params[:user] = check_access_token[:uid]
      params.slice(:model, :file, :prompt, :user)
    end

    def chat_params
      params[:user] = check_access_token[:uid]
      params.slice(:model, :messages,  :max_tokens, :temperature, :stream, :stream_options,
        :stop, :response_format, :tools, :functions, :tool_choice, :function_call, :seed,
        :frequency_penalty, :presence_penalty, :n, :logit_bias, :logprobs, :top_logprobs, :top_p,
        :user)
    end

    def embedding_params
      params[:user] = check_access_token[:uid]
      params.slice(:model, :input, :encoding_format, :dimensions, :user)
    end

    def get_mime_type_for response_format
      case response_format
      when %w[aac flac wav pcm]
        return "audio/#{response_format}"
      when 'opus'
        return 'audio/opus'
      else
        return 'audio/mpeg'
      end
    end

    def to_json data
      content_type 'application/json'
      Oj.dump(data)
    end

    def openai_client
      @@openai_client ||= OpenAI::Client.new(
        uri_base: 'https://api.openai.com/v1',
        access_token: ENV['OPENAI_ACCESS_TOKEN'])
    end
end
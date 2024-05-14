require 'sinatra/base'
require 'sinatra/cors'

class ProxyController < Sinatra::Base
  register Sinatra::Cors

  set :allow_methods, "POST"
  set :allow_origin, "*"
  set :allow_headers, "content-type,authorization"
  set :log_messages, true

  post '/audio/speech' do
    audio_data = openai_client.audio.speech(parameters: speech_params)
    
    log_message(speech_params[:input], StringIO.new(audio_data)) if settings.log_messages

    content_type get_mime_type_for(speech_params[:response_format])
    audio_data
  rescue Faraday::ClientError => e
    halt e.response[:status], to_json(e.response[:body])
  end

  post '/audio/transcriptions' do
    transcription = openai_client.audio.transcribe(parameters: transcription_params)
    
    log_message(transcription[:text], params[:file]) if settings.log_messages

    to_json(transcription)
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

    def log_message content, file
      fork do
        chat = Chat.find(check_access_token['cid'])
        chat.log_message(content, params[:role], file)
      end if params[:role].present?
    end

    def check_access_token
      @token ||= JWT.decode(request.env['HTTP_AUTHORIZATION'][7..-1], ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError => e
      halt 403, to_json({ "error" => e.message })
    end

    def speech_params
      params[:user] = check_access_token['uid']
      params.slice(:model,
        :voice, :input,
        :response_format, :user)
    end

    def transcription_params
      params[:user] = check_access_token['uid']
      params[:file] = params[:file][:tempfile] if params[:file]
      params.slice(:model,
        :file, :prompt, :language,
        :response_format, :user)
    end

    def chat_params
      params[:user] = check_access_token['uid']
      params.slice(:model,
        :messages, :stream, :tools, :tool_choice,
        :max_tokens, :temperature, :top_p, :n, :seed,
        :response_format, :user,

        :frequency_penalty, :presence_penalty,
        :logit_bias, :logprobs, :top_logprobs,
        :stop, :functions, :function_call)
    end

    def embedding_params
      params[:user] = check_access_token['uid']
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
require 'faraday'
require 'openai'

require 'oj'

require 'sinatra/base'

module Sinatra
  module OpenAI
    module Helpers
      def openai_client
        ::OpenAI::Client.new(uri_base: 'https://api.openai.com/v1', access_token: ENV['OPENAI_ACCESS_TOKEN'])
      end

      def to_json data
        content_type 'application/json'
        puts data
        ::Oj.dump(data)
      end

      def speech_params
        params[:user] = token['jti']
        params.slice(:model,
          :voice, :input, :speed,
          :response_format, :user)
      end

      def transcription_params
        params[:user] = token['jti']
        params[:file] = params[:file][:tempfile] if params[:file]
        params.slice(:model,
          :file, :prompt, :language,
          :response_format, :user)
      end

      def chat_params
        params[:user] = token['jti']
        params.slice(:model,
          :messages, :stream, :tools, :tool_choice,
          :max_tokens, :temperature, :top_p, :n, :seed,
          :response_format, :user,

          :frequency_penalty, :presence_penalty,
          :logit_bias, :logprobs, :top_logprobs,
          :stop, :functions, :function_call)
      end

      def embedding_params
        params[:user] = token['jti']
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
    end

    def self.registered(app)
      app.helpers Helpers

      app.post '/audio/speech' do
        content_type get_mime_type_for(speech_params[:response_format])
        openai_client.audio.speech(parameters: speech_params)
      rescue Faraday::ClientError => e
        halt e.response[:status], to_json(e.response[:body])
      end

      app.post '/audio/transcriptions' do
        transcription = openai_client.audio.transcribe(parameters: transcription_params)
        to_json(transcription)
      rescue Faraday::ClientError => e
        halt e.response[:status], to_json(e.response[:body])
      end

      app.post '/chat/completions' do
        content_type 'text/event-stream'
        stream do |sse|
          params[:stream] = proc { |data| sse << "data: #{Oj.dump(data)}\n\n" }
          openai_client.chat(parameters: chat_params)
          sse << "data: [DONE]\n\n"
        end if params[:stream]
        unless params[:stream]
          to_json(openai_client.chat(parameters: chat_params))
        end
      rescue Faraday::ClientError => e
        halt e.response[:status], to_json(e.response[:body])
      end

      app.post '/embeddings' do
        to_json(openai_client.embeddings(parameters: embedding_params))
      rescue Faraday::ClientError => e
        halt e.response[:status], to_json(e.response[:body])
      end

      app.before do
        authorize! unless request.path_info == '/auth'
        pass if request.env['CONTENT_TYPE'] != 'application/json'
        json = Oj.load(request.body.read)
        json.each { |k, v| params[k] = v } if json
      end
    end
  end
end
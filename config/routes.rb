Rails.application.routes.draw do
  namespace :api do
    resources :prompt, path: '/', only: %i[show] do
      post :auth, on: :collection
      resources :chat, only: %i[create show] do
        post :speech, to: 'api/chat#speech', on: :member
        post :transcriptions, to: 'api/chat#transcriptions', on: :member
      end
    end
  end

  resources :prompts do
    resources :chats
  end
  resources :users

  get '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  post '/auth', to: 'users#auth'
  
  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  resources :api, only: %i[create show] do
    post :message, on: :member
  end

  get '/c', to: 'c#show'

  resources :prompts do
    resources :chats
  end
  resources :users

  get '/login', to: 'users#login'
  delete '/logout', to: 'users#logout'
  post '/auth', to: 'users#auth'
  
  get "up" => "rails/health#show", as: :rails_health_check
end

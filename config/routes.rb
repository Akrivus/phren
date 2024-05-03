Rails.application.routes.draw do
  resources :people do
    resources :documents
    resources :memories
    resources :chats do
      resources :messages
    end
  end
  resources :users

  get '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  post '/auth', to: 'users#auth'
  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth" => "api_key#auth"
      resources :people, only: %i[index show] do
        resources :chats, only: %i[create show update destroy]
       #resources :documents
       #resources :memories
      end
    end
  end

  resources :people do
    resources :chats
   #resources :documents
   #resources :memories
  end
  resources :users

  get '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  post '/auth', to: 'users#auth'
  get "up" => "rails/health#show", as: :rails_health_check
end

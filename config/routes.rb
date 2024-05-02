Rails.application.routes.draw do
  resources :friends do
    resources :documents
    resources :memories
    resources :chats do
      resources :messages
    end
  end
  resources :users

  get "up" => "rails/health#show", as: :rails_health_check
end

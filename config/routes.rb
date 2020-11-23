Rails.application.routes.draw do
  namespace :api do
    devise_for :users, controllers: {
        sessions: 'api/users/sessions',
        registrations: 'api/users/registrations'
    }
    resources :cards, only: [:index]
    resources :decks, only: [:index, :show, :create, :update]
  end
end
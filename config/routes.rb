Rails.application.routes.draw do
  namespace :api do
    resources :cards, only: [:index]
    resources :decks, only: [:index, :show, :create, :update]
  end
end

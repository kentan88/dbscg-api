Rails.application.routes.draw do
  namespace :api do
    devise_for :users, controllers: {
        sessions: 'api/users/sessions',
        registrations: 'api/users/registrations'
    }

    resources :rooms, only: [:index, :show]
    resources :cards, only: [:index]
    resources :pricings, only: [:index]

    resources :decks, only: [:index, :show, :create, :destroy] do
      member do
        post :modify
        post :clone
        put :make_public_private
      end
    end

    resources :users, only: [] do
      collection do
        get :info
        get :album
      end
    end

    match '/landing', to: 'landing#index', via: :get
    match '/albums/:number', to: 'albums#update', via: :put
  end


  mount ActionCable.server => '/cable'
end
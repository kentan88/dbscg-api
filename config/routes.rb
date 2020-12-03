Rails.application.routes.draw do
  namespace :api do
    devise_for :users, controllers: {
        sessions: 'api/users/sessions',
        registrations: 'api/users/registrations'
    }

    resources :cards, only: [:index] do
      collection do
        get :leaders
      end
    end

    resources :decks, only: [:index, :show, :create] do
      member do
        post :modify
        post :clone
      end
    end

    resources :albums, only: [:update]

    resources :users, only: [] do
      collection do
        get :info
      end
    end
  end
end
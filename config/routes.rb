Rails.application.routes.draw do
  namespace :api do
    devise_for :users, controllers: {
        sessions: 'api/users/sessions',
        registrations: 'api/users/registrations'
    }
    resources :cards, only: [] do
      collection do
        get :ratings
        get :leaders
      end
    end
    resources :decks, only: [:index, :show, :create, :update] do
      member do
        post :clone
      end
    end
  end
end
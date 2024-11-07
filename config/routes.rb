Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :products, only: %i[show]
  resource :cart, only: %i[show] do
    resources :cart_items, only: %i[create destroy], module: :cart
  end
  resources :purchases, only: %i[index new create show]
  resource :address, only: %i[new create edit update]

  devise_for :admins, controllers: {
    sessions: "admins/sessions"
  }
  namespace :admin do
    root 'products#new', as: :root
    resources :products, only: %i[new create edit update]
  end
end

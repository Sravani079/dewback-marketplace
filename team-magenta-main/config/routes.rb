# frozen_string_literal: true

Rails.application.routes.draw do
  get 'notifications/index'
  get 'notifications/mark_as_read'
  

  namespace :admin do
    get 'users/index'
  end

  # Devise authentication for users
  devise_for :users

  # Root path
  root "catalog#index"

  # Catalog route
  get "/starwars/dewback", to: "catalog#index", as: :dewback_catalog
  resources :catalog, only: [:index]

  # Trade market
  get '/trade_market', to: 'trade_market#index', as: 'trade_market'

  # Dewbacks
  resources :dewbacks, only: [:show] do
    resources :reviews, only: [:create]
  end

  # Cart
  post '/add_to_cart/:dewback_id', to: 'carts#add_to_cart', as: 'add_to_cart'
  resource :cart, only: [:show, :update, :destroy]
  post '/reorder_cart/:order_id', to: 'carts#reorder', as: 'reorder_cart'

  # Orders
  resources :orders, only: [:new, :create, :show] do
    member do
      get 'confirmation'
      post 'reorder'
    end
  end
  

  # My Dewbacks
  resources :my_dewbacks, only: [:index] do
    member do
      patch :mark_for_trade
      patch :remove_from_trade
    end
  end

  resources :wishlists, only: [:index, :create, :destroy]

  # Admin Dewbacks
  resources :admin_dewbacks, only: [:index, :new, :create, :edit, :update]

  # Trade Proposals
  resources :trade_proposals, only: [:new, :create]

  # Trade Inbox
  get '/trade_inbox', to: 'trade_inbox#index', as: 'trade_inbox'
  get '/trade_inbox/:id', to: 'trade_inbox#show', as: 'trade_proposal_details'
  post '/trade_inbox/:id/accept', to: 'trade_inbox#accept', as: 'accept_trade_inbox'
  post '/trade_inbox/:id/reject', to: 'trade_inbox#reject', as: 'reject_trade_inbox'

  # Admin
  namespace :admin do
    resources :users, only: [:index] do
      patch :promote, on: :member
    end
  end

  # Profile
  resource :profile, controller: 'users', only: [:edit, :update]

  # Wishlist
  resources :wishlists, only: [:index, :create]


  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :trade_proposals do
    member do
      get :counter
      post :create_counter
    end
  end
  
  # config/routes.rb
  resources :trade_inbox, only: [:index]

  resources :my_dewbacks, only: [:index]

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
  
end

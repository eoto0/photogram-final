Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, sign_out_via: [:get, :delete]

  # Root page
  root "users#index"

  # Photos and nested likes/comments
  resources :photos do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  # Users: username as identifier
  resources :users, only: [:index, :show], param: :id do
    member do
      get :liked_photos
      get :feed
      get :discover
    end
  end

  # Follow requests
  resources :follow_requests, only: [:create, :update, :destroy]
end

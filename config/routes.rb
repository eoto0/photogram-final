Rails.application.routes.draw do
  get 'photos/index'
  get 'photos/show'
  get 'photos/create'
  get 'photos/destroy'
  devise_for :users, sign_out_via: [:get, :delete]
  root "users#index"

  resources :photos do
    resources :comments, only: [:create, :destroy]
    resources :likes,    only: [:create, :destroy]
  end

  resources :users, only: [:index, :show], param: :id do
    member do
      get :liked_photos
      get :feed
      get :discover
    end
  end

  resources :follow_requests, only: [:create, :destroy]
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

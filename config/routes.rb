Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create, :destroy] do
    collection do
      post :restart
    end
  end

  namespace :admin do
    root to: "admins#index"
    resources :cpu_comments, except: [:show]
    resources :words, only: [:index, :edit, :update, :destroy]
  end

  # Defines the root path route ("/")
  root "home#index"
end

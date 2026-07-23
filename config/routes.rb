Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create, :destroy] do
    collection do
      post :restart
    end
  end

  # Defines the root path route ("/")
  root "home#index"
end

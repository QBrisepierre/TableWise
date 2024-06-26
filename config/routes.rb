Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  root "pages#home"
  resources :restaurants, except: [ :index ] do
    member do
      get :dashboard
      get :search
    end
    collection do
      post :import
      post :import_list
    end
  end
  resources :customers, only: [ :create]
  resources :no_shows, only: [ :create]
end

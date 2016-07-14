Rails.application.routes.draw do
  root "home#index"

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get "/home" => "home#index"
  get "/about" => "home#about"

  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
    resources :favourites, only: [:create, :destroy]
  end

  resources :users do
    resources :favourites, only: [:index]
  end

  get "/users/:id/change_password" => "users#change_password", as: :change_password
  post "/users/:id/change_password" => "users#update_password"
  patch "/users/:id/change_password" => "users#update_password"

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

end

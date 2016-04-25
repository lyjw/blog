Rails.application.routes.draw do

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

  root "home#index"

  # Route helper, i.e. as: :new_question
  # get "/questions/new"      => "questions#new"    ,  as: :new_question
  # post "/questions"         => "questions#create" ,  as: :questions
  # get "/questions/:id"      => "questions#show"   ,  as: :question
  # get "/questions"          => "questions#index"
  # get "/questions/:id/edit" => "questions#edit"   ,  as: :edit_question
  # patch "/questions/:id"    => "questions#update"
  # delete "/questions/:id"   => "questions#destroy",  as: :delete_question



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

Rails.application.routes.draw do
  get '/admin', to: 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :line_items
  resources :carts
  root 'store#index', as: 'store_index'
  resources :products
  resources :orders, only: [:new, :create]
end

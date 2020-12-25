Rails.application.routes.draw do
  root 'homes#top'
  get 'homes/about'

  devise_for :users
  resources :users, only:[:index, :edit, :update]
  get 'users/my_page/:id' => 'users#show', as: 'my_page'
  get 'users/unsubscribe'
  patch 'users/withdraw'
end

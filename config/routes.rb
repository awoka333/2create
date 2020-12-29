Rails.application.routes.draw do
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  resources :users, only:[:index, :edit, :update]
  get 'users/my_page/:id' => 'users#show', as: 'my_page'
  get 'users/unsubscribe'
  patch 'users/withdraw'

  resources :activities
  get 'activities/public'

  resources :groups, only:[:show, :create, :update, :destroy]

end

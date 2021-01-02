Rails.application.routes.draw do
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  resources :users, only:[:index, :edit, :update]
  get 'users/my_page/:id' => 'users#show', as: 'my_page'
  get 'users/unsubscribe'
  patch 'users/withdraw'

  resources :activities
  get 'activities/modify'

  resources :groups, only:[:show, :create, :update, :destroy]

  resources :works
  get 'works/modify'
  patch 'works/mask'
  patch 'works/share'

  resources :themes, only:[:edit, :update]

  resources :comments, only:[:index, :create, :update, :destroy]
  get 'comments/modify'

  resources :favoretes, only:[:create, :destroy]
end

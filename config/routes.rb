Rails.application.routes.draw do
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  patch 'users/withdraw'
  resources :users, only: [:index, :edit, :update]
  get 'users/my_page' => 'users#show', as: 'my_page'
  get 'users/unsubscribe'

  get 'activities/modify'
  resources :activities

  resources :groups, only: [:show, :create, :update, :destroy]

  get 'works/modify'
  patch 'works/mask'
  resources :works

  resources :themes, only: [:new, :create]

  get 'comments/modify'
  resources :comments, only: [:index, :edit, :create, :update, :destroy]

  resources :favorites, only: [:create, :destroy]

  resources :recommends, only: [:create, :update]

  get 'search', to: 'search#search_result'
end

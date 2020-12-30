Rails.application.routes.draw do
  get 'themes/edit'
  get 'works/new'
  get 'works/index'
  get 'works/show'
  get 'works/modify'
  get 'works/edit'
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

end

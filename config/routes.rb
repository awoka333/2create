Rails.application.routes.draw do
  get 'groups/show'
  get 'activities/new'
  get 'activities/index'
  get 'activities/show'
  get 'activities/public'
  get 'activities/edit'
  devise_for :users
  root 'homes#top'
  get 'homes/about'

  resources :users, only:[:index, :edit, :update]
  get 'users/my_page/:id' => 'users#show', as: 'my_page'
  get 'users/unsubscribe'
  patch 'users/withdraw'
end

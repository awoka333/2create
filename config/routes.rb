Rails.application.routes.draw do
  devise_for :users

  root 'homes#top'
  get 'homes/about'

  resources :users, only:[:index, :edit, :update]
  get 'users/my_page' => 'users#show', as: 'my_page'
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

  resources :comments, only:[:index, :edit, :create, :update, :destroy]
  get 'comments/modify'

  resources :favorites, only:[:create, :destroy]

  resources :recommends, only:[:create, :update]

  get 'search', to: 'search#activity_search', as: 'activity_search'
  get 'search', to: 'search#work_search', as: 'work_search'
end

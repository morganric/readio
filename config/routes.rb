Rails.application.routes.draw do
  resources :items
  resources :feeds

  get '/latest' => 'items#latest', as: :latest
   get '/fresh' => 'items#fresh', as: :fresh
    get '/featured' => 'items#featured', as: :featured

  get '/items/:id/play' => 'items#plays', as: :item_play

  mount Upmin::Engine => '/admin'
  root to: 'items#index'
  devise_for :users
  resources :users
end

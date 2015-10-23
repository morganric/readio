Rails.application.routes.draw do
  resources :items
  resources :feeds

  get '/latest' => 'items#latest', as: :latest
  get '/fresh' => 'items#fresh', as: :fresh
  get '/featured' => 'items#featured', as: :featured
  get '/category' => 'feeds#category', as: :category
    get '/categories' => 'feeds#categories', as: :categories

  get '/item/:id' => 'items#show', as: :feed_item

  get '/items/:id/play' => 'items#plays', as: :item_play

  mount Upmin::Engine => '/admin'
  root to: 'items#index'
  devise_for :users
  resources :users
end

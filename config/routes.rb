Rails.application.routes.draw do
  resources :products
  resources :galleries
  resources :posts
  get 'requests/index'

  resources :industries, path: '/i' do
    get 'search', to: 'search#index'
    resources :search, only: [:index] # to generate the view helpers
    resources :requests, only: [:index]
  end

  resources :occupations, path: '/o' do
    get 'search', to: 'search#index'
    resources :search, only: [:index] # to generate the view helpers
    resources :requests, only: [:index]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get 'requests/index'
  # resources :n, controller: :niches
  resources :niches, path: '/n' do
    get 'search', to: 'search#index'
    resources :search, only: [:index] # to generate the view helpers
    resources :requests, only: [:index]
  end
  # resources :niches
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

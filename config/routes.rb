Rails.application.routes.draw do
  resources :categories
  resources :products
  resources :galleries
  resources :posts
  resources :industries
  resources :occupations
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

  resources :industry_categories, controller: :categories, type: "IndustryCategory", path: '/dir/i'

  resources :occupation_categories, controller: :categories, type: "OccupationCategory", path: '/dir/o'


  # resources :occupation_categories, path: '/dir/o'

  # resources :industry_categories, path: '/dir' do


end

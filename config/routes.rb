Rails.application.routes.draw do
  devise_for :users
  resources :industries, type: "Industry", path: "/i" do
    member do
      get 'search'
    end
    # , to: 'search#index'
    # resources :search, only: [:index] # to generate the view helpers
    resources :requests, only: [:index]
  end

  resources :occupations, type: "Occupation", path: "/o" do
    member do
      get 'search'
    end
    resources :requests, only: [:index]
  end

  mount Commontator::Engine => '/commontator'

  resources :categories
  resources :products
  resources :galleries
  resources :posts
  get 'requests/index'

  # resources :industries, path: '/i' do
  #   get 'search', to: 'search#index'
  #   resources :search, only: [:index] # to generate the view helpers
  #   resources :requests, only: [:index]
  # end

  resources :industry_categories, path: '/explore/i'
  resources :occupation_categories, path: '/explore/o'
  # resources :occupation_categories, controller: :categories, type: "OccupationCategory", path: '/explore/o'


  # resources :occupation_categories, path: '/dir/o'

  # resources :industry_categories, path: '/dir' do


end

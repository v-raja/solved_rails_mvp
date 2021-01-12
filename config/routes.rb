Rails.application.routes.draw do
  devise_for :users
  resources :industries, type: "Industry", path: "/i" do
    member do
      get 'search'
    end
    # , to: 'search#index'
    # resources :search, only: [:index] # to generate the view helpers
    # resources :requests, only: [:index]
    get "/", to: "posts#niche_index"
    get "/requests", to: "requests#niche_index"
  end

  root to: 'industry_categories#index'

  resources :occupations, type: "Occupation", path: "/o" do
    member do
      get 'search'
    end
    get "/", to: "posts#niche_index"
    get "/requests", to: "requests#niche_index"
  end

  resources :categories
  resources :products
  resources :galleries

  post 'posts/new', to: 'posts#create'
  resources :posts do
    collection do
      get 'preview_industries'
      get 'preview_occupations'
    end

    member do
      get 'upvote'
      get 'remove_upvote'
      resources :comments, except: :new do
        member do
          get 'upvote'
          get 'remove_upvote'
        end
      end
    end
  end

  post 'requests/new', to: 'requests#create'
  resources :requests do
    collection do
      get 'preview_industries'
      get 'preview_occupations'
    end
    member do
      get 'upvote'
      get 'remove_upvote'
      resources :comments, except: :new do
        member do
          get 'upvote'
          get 'remove_upvote'
        end
      end
    end
  end

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

Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations' }
  resources :users

  authenticate :user, -> (user) { user.admin? } do
    mount PgHero::Engine, at: "pghero"
  end

  # get 'welcome', to: 'users#welcome', as: :user_welcome
  resources :after_signup, path: "/welcome"


  root to: 'search#home'
  get 'recent', to: 'search#recent'
  get 'requests', to: 'search#requests'
  get 'requests/recent', to: 'search#requests_recent'


  resources :industries, only: [], type: "Industry", path: "/i" do
    get "/", to: "solutions#niche_index"
    get "/requests", to: "requests#niche_index"
    get "/search", to: "search#niche_index"
    member do
      get 'follow'
      get 'unfollow'
    end
  end

  resources :occupations, only: [], type: "Occupation", path: "/o" do
    get "/", to: "solutions#niche_index"
    get "/requests", to: "requests#niche_index"
    get "/search", to: "search#niche_index"
    member do
      get 'follow'
      get 'unfollow'
    end
  end

  resources :products, only: [:index, :show]


  post 'solutions/new', to: 'solutions#create'
  resources :solutions, except: [:index] do
    member do
      get 'follow'
      get 'unfollow'
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
    member do
      get 'upvote'
      get 'remove_upvote'
      get 'follow'
      get 'unfollow'
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

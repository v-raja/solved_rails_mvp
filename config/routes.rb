Rails.application.routes.draw do
  resources :mini_requests, only: :create
  resources :feedbacks, only: :create
  resources :lists
  match '/404', via: :all, to: 'errors#not_found'
  match '/422', via: :all, to: 'errors#unprocessable_entity'
  match '/500', via: :all, to: 'errors#server_error'
  get "/robots.:format", to: "errors#robots"

  devise_for :users, controllers: { confirmations: 'confirmations', invitations: 'users/invitations', registrations: 'users/registrations', sessions: 'users/sessions' }

  authenticate :user, -> (user) { user.admin? } do
    mount PgHero::Engine, at: "pghero"
  end

  resources :after_signup, path: "/welcome"
  resources :suggested_keywords, only: [:create, :destroy]
  resources :suggested_communities, only: [:create, :destroy]

  resources :groups, only: [:show], path: "/l"

  root to: 'home#all'
  get '/search/solutions', to: 'search#solutions'

  get 'home', to: 'home#home'
  get 'recent', to: 'home#recent'
  # get 'requests', to: 'home#requests'
  # get 'requests/recent', to: 'home#requests_recent'
  get 'all', to: 'home#all'
  # get '/search/requests', to: 'search#requests'

  resources :industries, only: [], type: "Industry", path: "/i" do
    get "/", to: "solutions#niche_index"
    # get "/requests", to: "requests#niche_index"
    get "/search", to: "search#niche_index"
    member do
      get 'follow'
      get 'unfollow'
    end
  end

  resources :occupations, only: [], type: "Occupation", path: "/o" do
    get "/", to: "solutions#niche_index"
    # get "/requests", to: "requests#niche_index"
    get "/search", to: "search#niche_index"
    member do
      get 'follow'
      get 'unfollow'
    end
  end

  resources :products, only: [:index, :show]

  # Force www redirect
  # Start server with rails s -p 3000 -b lvh.me
  # Then go to http://www.lvh.me:3000
  # constraints(host: /^(?!www\.)/i) do
  #   get "controller#action" => redirect { |params, request|
  #     URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
  #   }
  # end

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
          delete 'really_destroy'
          post 'restore'
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
          delete 'really_destroy'
          post 'restore'
        end
      end
    end
  end
  resources :industry_categories, path: '/explore/i'
  resources :occupation_categories, path: '/explore/o'


end

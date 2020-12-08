Rails.application.routes.draw do
  resources :n, controller: :niches, param: :slug
  resources :niches, param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

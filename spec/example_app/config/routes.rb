Rails.application.routes.draw do
  namespace :admin do
    resources :customers
    resources :line_items
    resources :orders
    namespace :catalog do
      resources :products
    end

    root to: "customers#index"
  end

  get "/:page", to: "docs#show"
  root to: "docs#index"
end

# config/routes.rb
Rails.application.routes.draw do
  root "forecasts#index"
  resources :forecasts, only: [:index]  # remove the manual POST route
end

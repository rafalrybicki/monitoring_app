Rails.application.routes.draw do
  devise_for :users

  root 'days#today'
  resources :days, only: %i[index show], param: :date
end

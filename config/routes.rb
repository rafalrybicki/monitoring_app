Rails.application.routes.draw do
  root 'days#today'
  
  resources :days, only: %i[index show], param: :date do
    resources :tasks, except: %i[index show]
  end

  devise_for :users
end

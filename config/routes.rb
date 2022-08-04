Rails.application.routes.draw do
  root 'days#today'

  resources :days, only: %i[index show], param: :date do
    resources :tasks, except: %i[index show]
  end

  resources :habits, except: %i[show] do
    resources :habit_items, only: %i[update]
  end

  devise_for :users
end

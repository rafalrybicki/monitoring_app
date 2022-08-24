Rails.application.routes.draw do
  root to: redirect('/today')

  get '/today', to: 'days#today'

  resources :days, only: %i[index show edit update] do
    resources :tasks, except: %i[index show] do
      member do
        patch 'reschedule'
      end
    end
  end

  resources :habits, except: %i[show] do
    resources :habit_items, only: %i[update]
  end

  resources :quotes, except: %i[show]

  devise_for :users
end

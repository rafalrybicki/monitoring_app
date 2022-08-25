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

  resources :habits, except: %i[show]

  resources :habit_items, only: %i[create update]

  resources :quotes, except: %i[show]

  devise_for :users
end

Rails.application.routes.draw do
  root to: redirect('/today')

  get '/today', to: 'days#today'

  resources :days, only: %i[index show edit update] do
    resources :tasks, except: %i[index show] do
      member do
        patch 'cancel'
      end
    end
  end

  resources :habits

  patch 'habit_item', to: 'habit_items#update'

  resources :quotes, except: %i[show]

  resources :notes

  devise_for :users
end

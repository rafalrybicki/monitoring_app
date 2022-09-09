Rails.application.routes.draw do
  get 'notes/index'
  get 'notes/new'
  get 'notes/create'
  get 'notes/edit'
  get 'notes/update'
  get 'notes/delete'
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

  resources :habit_items, only: %i[create update]

  resources :quotes, except: %i[show]

  resources :notes

  devise_for :users
end

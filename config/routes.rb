Rails.application.routes.draw do
  root to: redirect('/today')

  get '/today', to: 'days#today'

  resources :days, only: %i[index show], param: :date do
    resources :tasks, except: %i[index show]
    patch 'tasks/:id/reschedule', to: 'tasks#reschedule', as: 'task_reschedule'
  end

  resources :habits, except: %i[show] do
    resources :habit_items, only: %i[update]
  end

  devise_for :users
end

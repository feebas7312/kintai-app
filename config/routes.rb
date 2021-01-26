Rails.application.routes.draw do
  root to: 'admins#index'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  resources :admins, only: :index
end

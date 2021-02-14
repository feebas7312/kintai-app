Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  devise_scope :admin do
    get 'companies', to: 'admins/registrations#new_company'
    post 'companies', to: 'admins/registrations#create_company'
  end

  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    passwords: 'employees/passwords',
    registrations: 'employees/registrations'
  }

  root to: 'admins_home#index'
  resources :admins_home, only: [:index, :show, :destroy]
  resources :employees_home, only: [:index, :show]
  resources :companies, only: [:show, :edit, :update] do
    resources :work_patterns, only: [:new, :create]
  end
  resources :work_schedules, only: [:new, :create] do
    collection do
      get 'search'
    end
  end
end

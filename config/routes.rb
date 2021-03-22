Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  # get 'admins/show', to: 'admins#show'

  devise_scope :admin do
    get 'companies', to: 'admins/registrations#new_company'
    post 'companies', to: 'admins/registrations#create_company'
  end

  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    passwords: 'employees/passwords',
    registrations: 'employees/registrations'
  }

  # get 'employees/show', to: 'employees#show'

  root to: 'companies#show'
  resources :admins_home, only: [:show, :destroy]
  resources :employees_home, only: [:show]
  resources :companies, only: [:show, :edit, :update] do
    resources :work_patterns, only: [:new, :create, :destroy]
  end
  resources :admin_work_patterns, only: [:new, :create]
  resources :employee_work_patterns, only: [:new, :create]
  resources :work_schedules, only: [:index, :new, :create, :destroy] do
    collection do
      get 'calculation'
    end
  end
end

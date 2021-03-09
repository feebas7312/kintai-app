Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations'
  }

  get 'admins/show', to: 'admins#show'

  devise_scope :admin do
    get 'companies', to: 'admins/registrations#new_company'
    post 'companies', to: 'admins/registrations#create_company'
  end

  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    passwords: 'employees/passwords',
    registrations: 'employees/registrations'
  }

  get 'employees/show', to: 'employees#show'

  root to: 'admins_home#index'
  resources :admins_home, only: [:index, :show, :destroy]
  resources :employees_home, only: [:index, :show]
  resources :companies, only: [:show, :edit, :update] do
    resources :work_patterns, only: [:new, :create, :destroy]
  end
  resources :admin_work_patterns, only: [:create]
  resources :employee_work_patterns, only: [:create]
  resources :work_schedules, only: [:index, :new, :create] do
    collection do
      get 'calculation'
    end
  end
end

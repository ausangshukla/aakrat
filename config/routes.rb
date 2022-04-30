Rails.application.routes.draw do
  resources :quotes
  resources :attachments do
    patch 'toggle_approval', on: :member
  end
  resources :site_visits
  resources :project_accesses
  resources :clients do
    get 'search', on: :collection
  end

  resources :steps do
    patch 'toggle_completed', on: :member
  end

  resources :notes

  resources :phases do
    patch 'toggle_completed', on: :member
  end

  resources :projects do
    patch 'clone_phases', on: :member
    post 'clone', on: :member
    post 'delete_attachment', on: :collection
  end

  resources :payments

  namespace :admin do
    resources :users
    resources :companies
    resources :roles

    root to: "users#index"
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: 'users/confirmations'
  }

  resources :companies do
    get 'search', on: :collection
    get 'investor_companies', on: :collection
    get 'dashboard', on: :collection
    get 'investor_view', on: :member
  end

  resources :users do
    get 'search', on: :collection
    get 'welcome', on: :collection
    post 'reset_password', on: :collection
    post 'accept_terms', on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "companies#dashboard"

  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end

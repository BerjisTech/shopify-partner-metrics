# frozen_string_literal: true

Rails.application.routes.draw do
  resources :invite_accepts
  resources :invites
  resources :staffs
  resources :running_metrics
  resources :external_metrics
  authenticated :user do
    resources :platforms
    resources :industries
    resources :app_plans
    resources :plan_data
    resources :running_data
    resources :third_party_apis
    resources :apps
    resources :businesses
    get 'dashboard', controller: :dashboard, action: :index
    get 'test/data/running/:app_id', controller: :running_data, action: :test, as: :test_running_data
    get 'import/shopify/:data_set', controller: :importer, action: :shopify
  end

  get 'home/index'
  get 'home/about'
  get 'home/pricing'
  get 'home/faq'
  get 'home/api'
  get 'docs', controller: :docs, action: :big_dicky

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  post 'verify_email', controller: :application, action: :verify_email

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

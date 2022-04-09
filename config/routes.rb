# frozen_string_literal: true

Rails.application.routes.draw do
  authenticated :user do
    resources :platforms
    resources :industries
    resources :app_plans
    resources :plan_data
    resources :running_data
    resources :third_party_apis
    resources :apps
    resources :businesses
    resources :app_teams
    resources :invite_accepts
    resources :invites
    resources :staffs
    resources :running_metrics
    resources :external_metrics
    get 'dashboard', controller: :dashboard, action: :index
    get 'test/data/running/:app_id', controller: :running_data, action: :test, as: :test_running_data
    get 'import/shopify/:data_set/:start', controller: :importer, action: :shopify, as: :shopify_import
    get 'import/shopify_test', controller: :importer, action: :shopify_test, as: :shopify_test_import
    post 'shopify_importer_setup', controller: :third_party_apis, action: :shopify_importer_setup
    post 'pfd', controller: :running_data, action: :pull_first_data
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

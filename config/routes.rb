# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

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

    ######### IMPORTS
    get 'test/data/running/:app_id', controller: :running_data, action: :test, as: :test_running_data
    get 'import/shopify/:data_set/:start', controller: :importer, action: :shopify, as: :shopify_import
    get 'import/shopify_test', controller: :importer, action: :shopify_test, as: :shopify_test_import
    post 'shopify_importer_setup', controller: :third_party_apis, action: :shopify_importer_setup
    post 'pfd', controller: :running_data, action: :pull_first_data, as: :pfd

    ########## CHARTS
    post 'main_external_pie', controller: :external_metrics, action: :main_external_pie
    post 'main_external_bar', controller: :external_metrics, action: :main_external_bar
    post 'business_user_growth_bar', controller: :external_metrics, action: :business_user_growth_bar
    post 'app_user_growth_bar/:app_id', controller: :external_metrics, action: :app_user_growth_bar,
                                        as: :app_user_growth_bar
    post 'business_revenue_breakdown_chart', controller: :external_metrics, action: :business_revenue_breakdown_chart
    post 'app_revenue_chart/:app_id/:platform_id', controller: :external_metrics, action: :app_revenue_chart,
                                                   as: :app_revenue_chart
    post 'app_mrr/:app_id/:platform_id', controller: :external_metrics, action: :app_mrr,
                                         as: :app_mrr

    ########## ANALYTICS PAGES
    get 'metrics/users', controller: :metrics, action: :users, as: :users_metrics
    get 'metrics/gross', controller: :metrics, action: :gross, as: :gross_metrics
    get 'metrics/net', controller: :metrics, action: :net, as: :net_metrics
    get 'metrics/arr', controller: :metrics, action: :arr, as: :arr_metrics
    get 'metrics/usergrowth', controller: :metrics, action: :user_growth, as: :business_user_growth_metrics
    get 'metrics/refunds', controller: :metrics, action: :refunds, as: :refund_metrics
    get 'metrics/onetime', controller: :metrics, action: :one_time, as: :one_time_metrics
    get 'metrics/recurring', controller: :metrics, action: :recurring, as: :recurring_metrics
    get 'metrics/revenue_breakdown', controller: :metrics, action: :revenue_breakdown, as: :revenue_breakdown

    ########## TABLE DATA PAGES
    post 'user_activity', controller: :external_metrics, action: :user_activity
  end

  ##### Important external links
  get 's/f/w', controller: :importer, action: :from_whenever

  get 'home/index'
  get 'home/about'
  get 'home/pricing'
  get 'home/faq'
  get 'home/api'
  get 'docs', controller: :docs, action: :big_dicky
  get 'confirm', controller: :misc, action: :confirm

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  post 'verify_email', controller: :application, action: :verify_email

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

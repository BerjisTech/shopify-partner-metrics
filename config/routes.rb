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
    # resources :plans
    # resources :billings
    get 'dashboard', controller: :dashboard, action: :index
    get 'account', controller: :account, action: :index

    ######### PLANS AND BILLING
    get 'billing', controller: :billings, action: :billing
    get 'billing/all', controller: :billings, action: :index
    get 'bill/:id', controller: :billings, action: :show, as: :bill
    get 'billing/change_plan/:app_id/:current_plan/:new_plan', controller: :billings, action: :change_plan,
                                                               as: :change_plan
    get 'update_plan', controller: :billings, action: :show

    get 'stripe_session/:line_items', controller: :billings, action: :stripe_session, as: :stripe_session
    post 'stripe_subscribe', controller: :billings, action: :stripe_subscribe
    post 'stripe_portal', controller: :billings, action: :stripe_portal
    get 'stripe/success/:apps', controller: :billings, action: :success, as: :stripe_success
    get 'stripe/cancel/:apps', controller: :billings, action: :cancel, as: :stripe_cancel

    get 'billing/downgrade_batch', controller: :billings, action: :downgrade, as: :downgrade_batch
    get 'billing/downgrade', controller: :billings, action: :downgrade, as: :downgrade

    get 'billing/upgrade_batch', controller: :billings, action: :upgrade, as: :upgrade_batch
    get 'billing/upgrade', controller: :billings, action: :upgrade, as: :upgrade

    get 'billing/pay_batch', controller: :billings, action: :pay_batch, as: :pay_batch
    get 'billing/pay_all', controller: :billings, action: :pay_all, as: :pay_all
    get 'billing/pay', controller: :billings, action: :pay_all, as: :pay

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

    ########## App Pages
    get 'team/:app_id', controller: :app_teams, action: :for_app, as: :team

    ########## Business Pages
    get 'staff/:business_id', controller: :staffs, action: :for_app, as: :employee
  end

  post 'stripe/webhook', controller: :billings, action: :stripe_webhook
  get 'stripe/webhook', controller: :billings, action: :stripe_webhook
  get 'webhook_json', controller: :billings, action: :webhook_json

  ##### Important external links
  get 's/f/w', controller: :importer, action: :from_whenever

  get 'home/index'
  get 'home/about'
  get 'home/pricing'
  get 'home/faq'
  get 'home/api'
  get 'docs', controller: :docs, action: :big_dicky
  get 'confirm', controller: :misc, action: :confirm

  ###### Docs
  get 'docs/:id', controller: :docs, action: :doc, as: :doc

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
                     controllers: { registrations: 'registrations' }

  post 'verify_email', controller: :application, action: :verify_email

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

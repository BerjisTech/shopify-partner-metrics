# frozen_string_literal: true

Rails.application.routes.draw do
  get 'dashboard', controller: :dashboard, action: :index

  get 'home/index'
  get 'home/about'
  get 'home/pricing'
  get 'home/faq'
  get 'home/api'

  
  devise_for :users
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

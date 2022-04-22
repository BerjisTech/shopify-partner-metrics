# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Platform.find_or_create_by!({ name: 'Shopify' })
Platform.find_or_create_by!({ name: 'Stripe' })
Platform.find_or_create_by!({ name: 'Paypal' })

Industry.find_or_create_by!({ name: 'eCommerce' })
Industry.find_or_create_by!({ name: 'Fashion' })
Industry.find_or_create_by!({ name: 'Food' })
Industry.find_or_create_by!({ name: 'Tours & Travel' })
Industry.find_or_create_by!({ name: 'IT' })

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password',
                    password_confirmation: 'password')
end

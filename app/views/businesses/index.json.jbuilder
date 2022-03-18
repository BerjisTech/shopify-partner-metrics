# frozen_string_literal: true

json.array! @businesses, partial: 'businesses/business', as: :business

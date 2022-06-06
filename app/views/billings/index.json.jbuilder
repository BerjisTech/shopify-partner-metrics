# frozen_string_literal: true

json.array! @billings, partial: 'billings/billing', as: :billing

# frozen_string_literal: true

class PaymentHistory < ApplicationRecord
  CHARGE_TYPES = ['App sale - usage',
                  'App sale - 30-day subscription',
                  'App downgrade',
                  'App sale - subscription',
                  'App refund',
                  'App credit'].freeze
  class << self
    def calculate_initial_metrics(app_id)
      mrr = PaymentHistory.where(app_id: app_id).group('month(payment_date)').select('SUM(partner_sale)').first
    end
  end
end

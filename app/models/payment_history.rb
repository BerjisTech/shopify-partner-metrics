# frozen_string_literal: true

class PaymentHistory < ApplicationRecord
    class << self
        def calculate_initial_metrics(app_id)
            mrr = PaymentHistory.where(app_id: app_id).group('month(payment_date)').select('SUM(partner_sale)').first
        end
    end
end

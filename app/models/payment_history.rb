# frozen_string_literal: true

class PaymentHistory < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id
  CHARGE_TYPES = ['App sale - usage',
                  'App sale - 30-day subscription',
                  'App downgrade',
                  'App sale - subscription',
                  'App refund',
                  'App credit'].freeze
  class << self
    def calculate_initial_metrics(app_id)
      from_csv = PaymentHistory
                 .where(app_id: app_id)
                 .group('month', :app_id)
                 .select(
                   "sum(case when charge_type = 'App refund' then partner_sale end) refunds",
                   "sum(case when charge_type = 'App sale – usage' or charge_type = 'App sale – 30-day subscription' or charge_type = 'App sale – subscription' then partner_sale end) income",
                   "sum(case when charge_type = 'App sale – usage' or charge_type = 'App sale – 30-day subscription' then partner_sale end) recurring_revenue",
                   "sum(case when charge_type = 'App sale – subscription' then partner_sale end) one_time_charge",
                   "date_trunc('month', payment_date) as month"
                 )

      update_metrics(from_csv, app_id)
    end

    def update_metrics(data, app_id)
      data.map do |_metric|
        ExternalMetric.create!(
          app_id: app_id,
          platform_id: PLATFORM,
          date: metric.month,
          recurring_revenue: metric.recurring_revenue,
          one_time_charge: metric.one_time_charge,
          refunds: metric.refunds,
          net: (metric.income + metric.refunds),
          gross: metric.income,
          arr: (metric.income * 12)
        )
      end
    end
  end
end

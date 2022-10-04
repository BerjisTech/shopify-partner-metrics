# frozen_string_literal: true

class PaymentHistory < ApplicationRecord
  PLATFORM = Platform.find_or_create_by!(name: 'Shopify').id
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
      data.map do |metric|
        external_metric = ExternalMetric.find_or_create_by!(
          app_id: app_id,
          platform_id: PLATFORM,
          date: metric.month
        )
        external_metric.update({
                                 recurring_revenue: metric.recurring_revenue.to_f,
                                 one_time_charge: metric.one_time_charge.to_f,
                                 refunds: metric.refunds.to_f,
                                 net: (metric.income.to_f + metric.refunds.to_f),
                                 gross: metric.income.to_f,
                                 arr: (metric.income.to_f * 12)
                               })
      end
    end
  end
end

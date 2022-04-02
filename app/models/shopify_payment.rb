# frozen_string_literal: true

class ShopifyPayment < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id
  class << self
    def data(time, cursor)
      "
        {
            transactions (
                first: 100
                types: [APP_SUBSCRIPTION_SALE APP_USAGE_SALE APP_SALE_ADJUSTMENT],
                after: \"#{cursor}\",
                createdAtMin: \"#{time[:start]}\",
                createdAtMax: \"#{time[:end]}\", ) {
                edges {
                    cursor
                    node {
                        id,
                        createdAt,
                        ... on AppSubscriptionSale {
                            netAmount {
                                amount
                            },
                            app {
                                name
                            },
                            shop {
                                id,
                                myshopifyDomain
                            }
                        },
                        ... on AppUsageSale {
                            netAmount {
                                amount
                            },
                            app {
                                name
                            },
                            shop {
                                id,
                                myshopifyDomain
                            }
                        },
                        ... on ServiceSale {
                            netAmount {
                                amount
                            },
                            shop {
                                myshopifyDomain
                            }
                        },
                        ... on AppSaleAdjustment {
                            netAmount {
                                amount
                            },
                            app {
                                name
                            },
                            shop {
                                id,
                                myshopifyDomain
                            }
                        },
                    }
                },
                pageInfo {
                    hasPreviousPage
                    hasNextPage
                }
            }
        }"
    end

    def process_data(data, app_id, date)
      {
        dailies: calculate_daily_financials(data),
        totals: calculate_net_mrr(data)
      }
      external_metric = ExternalMetric.find_or_create_by(app_id: app_id, date: date.to_date.strftime('%d-%m-%Y'))
    end

    def calculate_daily_financials(processed_data)
      recurring = processed_data.filter do |i|
                    i['node']['id'].include?('gid://partners/AppUsageSale/')
                  end.sum { |i| i['node']['netAmount']['amount'].to_f }
      one_time = processed_data.filter do |i|
                   i['node']['id'].include?('gid://partners/AppSubscriptionSale/')
                 end.sum { |i| i['node']['netAmount']['amount'].to_f }
      refund = processed_data.filter do |i|
                 i['node']['id'].include?('gid://partners/AppSaleAdjustment/')
               end.sum { |i| i['node']['netAmount']['amount'].to_f }

      {
        recurring_revenue: recurring,
        one_time_charge: one_time,
        refunds: refund
      }
    end

    def calculate_net_mrr(processed_data)
      total = processed_data.sum { |i| i['node']['netAmount']['amount'].to_f }

      refund = processed_data.filter do |i|
                 i['node']['id'].include?('gid://partners/AppSaleAdjustment/')
               end.sum { |i| i['node']['netAmount']['amount'].to_f }
      {
        mrr: total,
        net_revenue: (total - refund)
      }
    end
  end
end

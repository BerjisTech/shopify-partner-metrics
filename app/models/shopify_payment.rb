# frozen_string_literal: true

class ShopifyPayment < ApplicationRecord
  PLATFORM = Platform.find_or_create_by(name: 'Shopify').id
  class << self
    def gql_data(time, cursor)
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

    def process_data(data, app_id, date, platform, cursor, data_set)
      external_metric = ExternalMetric.find_or_create_by(app_id: app_id, platform_id: platform,
                                                         date: date.to_date.strftime('%d-%m-%Y'))

      if cursor == ''
        if data_set == 'daily_finance'
          clear_daily(external_metric)
        else
          clear_monthly(external_metric)
        end
      end

      updates = update_data(external_metric, data, data_set)

      external_metric.update(
        updates
      )
    end

    def gross(processed_data)
      processed_data.sum { |i| i['node']['netAmount']['amount'].to_f }
    end

    def net(processed_data)
      gross(processed_data) + refunds(processed_data)
    end

    def recurring_revenue(processed_data)
      processed_data.filter do |i|
        i['node']['id'].include?('gid://partners/AppUsageSale/')
      end.sum { |i| i['node']['netAmount']['amount'].to_f }
    end

    def one_time_charge(processed_data)
      processed_data.filter do |i|
        i['node']['id'].include?('gid://partners/AppSubscriptionSale/')
      end.sum { |i| i['node']['netAmount']['amount'].to_f }
    end

    def refunds(processed_data)
      processed_data.filter do |i|
        i['node']['id'].include?('gid://partners/AppSaleAdjustment/')
      end.sum { |i| i['node']['netAmount']['amount'].to_f }
    end

    def arr(processed_data)
      net(processed_data) * 12
    end

    def update_data(external_metric, data, data_set)
      if %w[daily_finance dailyfinance].include?(data_set)
        {
          recurring_revenue: (external_metric.recurring_revenue || 0) + recurring_revenue(data),
          one_time_charge: (external_metric.one_time_charge || 0) + one_time_charge(data),
          refunds: (external_metric.refunds || 0) + refunds(data)
        }
      else
        {
          net: (external_metric.net || 0) + net(data),
          gross: (external_metric.gross || 0) + gross(data),
          arr: (external_metric.arr || 0) + arr(data)
        }
      end
    end

    def clear_daily(external_metric)
      external_metric.update({
                               recurring_revenue: 0,
                               one_time_charge: 0,
                               refunds: 0
                             })
    end

    def clear_monthly(external_metric)
      external_metric.update({
                               net: 0,
                               gross: 0,
                               arr: 0
                             })
    end
  end
end

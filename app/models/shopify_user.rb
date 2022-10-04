# frozen_string_literal: true

class ShopifyUser < ApplicationRecord
  PLATFORM = Platform.find_or_create_by(name: 'Shopify').id
  class << self
    def gql_data(api, time, cursor)
      "
        {
            app(id: \"gid://partners/App/#{api.app_code}\") {
                id
                name
                events(
                first: 100,
                after: \"#{cursor}\",
                types: [RELATIONSHIP_REACTIVATED RELATIONSHIP_DEACTIVATED RELATIONSHIP_INSTALLED RELATIONSHIP_UNINSTALLED],
                occurredAtMin: \"#{time[:start]}\",
                occurredAtMax: \"#{time[:end]}\") {
                    edges {
                        cursor
                        node {
                            type
                            occurredAt
                            shop {
                                id,
                                myshopifyDomain
                            }
                            ... on RelationshipUninstalled {
                                reason
                                description
                            }
                        }
                    }
                    pageInfo {
                        hasPreviousPage
                        hasNextPage
                    }
                }
            }
        }"
    end

    def process_data(data, app_id, date, platform, cursor)
      external_metric = ExternalMetric.find_or_create_by(app_id: app_id, platform_id: platform,
                                                         date: date.to_date.strftime('%d-%m-%Y'))

      clear(external_metric) if cursor == ''

      updates = update_data(external_metric, data)

      external_metric.update(
        updates
      )
    end

    def total_installs(processed_data)
      installs = processed_data.select { |i| i['node']['type'] == 'RELATIONSHIP_INSTALLED' }.size
    end

    def total_uninstalls(processed_data)
      uninstalls = processed_data.select { |i| i['node']['type'] == 'RELATIONSHIP_UNINSTALLED' }.size
    end

    def total_deactivations(processed_data)
      deactivations = processed_data.select { |i| i['node']['type']  == 'RELATIONSHIP_DEACTIVATED' }.size
    end

    def total_reactivations(processed_data)
      reactivations = processed_data.select { |i| i['node']['type']  == 'RELATIONSHIP_REACTIVATED' }.size
    end

    def update_data(external_metric, data)
      {
        new_users: (external_metric.new_users || 0) + total_installs(data),
        lost_users: (external_metric.lost_users || 0) + total_uninstalls(data),
        deactivations: (external_metric.deactivations || 0) + total_deactivations(data),
        reactivations: (external_metric.reactivations || 0) + total_reactivations(data)
      }
    end

    def clear(external_metric)
      external_metric.update({
                               new_users: 0,
                               lost_users: 0,
                               deactivations: 0,
                               reactivations: 0
                             })
    end
  end
end

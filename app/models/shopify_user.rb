# frozen_string_literal: true

class ShopifyUser < ApplicationRecord
  PLATFORM = Platform.find_by(name: 'Shopify').id
  class << self
    def data(api, time, cursor)
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

    def process_data(data)
      {
        new_subscriptions: total_installs(data),
        closed_subscription: total_uninstalls(data),
        deactivations: total_deactivations(data),
        reactivations: total_reactivations(data)
      }
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
  end
end

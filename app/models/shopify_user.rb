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
  end
end

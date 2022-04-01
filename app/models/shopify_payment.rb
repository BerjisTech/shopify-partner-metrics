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
  end
end

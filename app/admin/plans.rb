# frozen_string_literal: true

ActiveAdmin.register Plan do
  config.sort_order = 'created_at_desc'

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :has_exports, :has_breakdown, :price, :has_csv_import, :visible
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :has_exports, :has_breakdown, :price, :has_csv_import]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  before_create do |plan|
    plan.price *= 100
    stripe_plan = Stripe::Plan.create({
                                        amount: plan.price.to_i,
                                        currency: 'USD',
                                        interval: 'month',
                                        product: 'prod_LquO1GrDvD0h5n' # 'prod_LpG7jyDigz4iCL'
                                      })
    plan.price_id = stripe_plan.id
  end

  # before_update do |plan|
  #   Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'

  #   Stripe::Plan.update(
  #     plan.price_id,
  #     { metadata: { order_id: '6735' } }
  #   )
  # end
end

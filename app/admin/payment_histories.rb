# frozen_string_literal: true

ActiveAdmin.register PaymentHistory do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :payout_period, :payment_date, :shop, :shop_country, :charge_creation_time, :charge_type, :category, :partner_sale, :shopify_fee, :processing_fee, :regulatory_operating_fee, :partner_share, :app_title, :theme_name, :tax_description, :charge_id, :app_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:payout_period, :payment_date, :shop, :shop_country, :charge_creation_time, :charge_type, :category, :partner_sale, :shopify_fee, :processing_fee, :regulatory_operating_fee, :partner_share, :app_title, :theme_name, :tax_description, :charge_id, :app_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

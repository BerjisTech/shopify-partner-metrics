# frozen_string_literal: true

ActiveAdmin.register Plan do
  config.sort_order = "created_at_desc"
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :has_exports, :has_breakdown, :price, :has_csv_import
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
    plan.price_id = current_user.id
  end
end

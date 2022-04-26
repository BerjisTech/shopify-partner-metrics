# frozen_string_literal: true

ActiveAdmin.register Business do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :business_name, :user_id, :industry_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:business_name, :user_id, :industry_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

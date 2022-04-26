# frozen_string_literal: true

ActiveAdmin.register App do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :app_name, :user_id, :platform_id, :business_id, :app_url, :running_data_endpoint, :data_rounds
  #
  # or
  #
  # permit_params do
  #   permitted = [:app_name, :user_id, :platform_id, :business_id, :app_url, :running_data_endpoint, :data_rounds]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

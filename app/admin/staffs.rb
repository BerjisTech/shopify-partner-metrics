# frozen_string_literal: true

ActiveAdmin.register Staff do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :business_id, :user_id, :status, :designation
  #
  # or
  #
  # permit_params do
  #   permitted = [:business_id, :user_id, :status, :designation]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

# frozen_string_literal: true

ActiveAdmin.register ErrorLog do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :activity, :message, :logs
  #
  # or
  #
  # permit_params do
  #   permitted = [:activity, :message, :logs]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

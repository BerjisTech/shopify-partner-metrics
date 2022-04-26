# frozen_string_literal: true

ActiveAdmin.register ThirdPartyApi do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :platform_id, :api_key, :api_secret, :secondary_api_key, :secondary_api_secret, :app_id, :partner_id, :app_code
  #
  # or
  #
  # permit_params do
  #   permitted = [:platform_id, :api_key, :api_secret, :secondary_api_key, :secondary_api_secret, :app_id, :partner_id, :app_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

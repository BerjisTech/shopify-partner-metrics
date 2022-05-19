# frozen_string_literal: true

ActiveAdmin.register Doc do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :topic, :description, :requests, :docs_category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:topic, :description, :requests, :docs_category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

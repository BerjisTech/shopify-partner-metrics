# frozen_string_literal: true

ActiveAdmin.register ExternalMetric do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :app_id, :gross, :net, :trial, :paying_users, :trial_users, :new_users, :lost_users, :mrr_chrun, :user_churn, :arpu, :platform_id, :deactivations, :reactivations, :date, :recurring_revenue, :one_time_charge, :refunds, :arr, :app_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:app_id, :gross, :net, :trial, :paying_users, :trial_users, :new_users, :lost_users, :mrr_chrun, :user_churn, :arpu, :platform_id, :deactivations, :reactivations, :date, :recurring_revenue, :one_time_charge, :refunds, :arr, :app_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

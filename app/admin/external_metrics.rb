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
  ActiveAdmin.register_page 'reset_imports' do
    controller do
      def index
        platform_id = Platform.find_or_create_by(name: 'Shopify').id

        job = ThirdPartyApi.where(platform_id: platform_id).map do |api|
          ExternalDataImportJob.set(wait: 10.seconds).perform_later(api.app_id, api,
                                                                    { start: (DateTime.now - 30.days).to_s, end: DateTime.now.to_s }, 'monthly_finance', '')

          ExternalDataImportJob.set(wait: 50.seconds).perform_later(api.app_id, api,
                                                                    { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'daily_finance', '')

          if api.partner_id.present? && api.app_code.present?
            ExternalDataImportJob.set(wait: 60.seconds).perform_later(api.app_id, api,
                                                                      { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'user', '')
          end
        end

        render json: job
      end
    end
  end
end

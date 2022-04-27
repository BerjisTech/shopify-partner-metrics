# frozen_string_literal: true

ActiveAdmin.register ImportLog do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :platform_id, :app_id, :start_time, :end_time, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:platform_id, :app_id, :start_time, :end_time, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  ActiveAdmin.register_page 'incomplete_logs' do
    content title: proc { 'Incomplete Imports' } do
      render partial: 'admin/incomplete_imports'
    end
  end

  ActiveAdmin.register_page 'rerun_import' do
    controller do
      def index
        import = ImportLog.find(params[:activity])
        api = ThirdPartyApi.find_by(app_id: import.app_id, platform_id: import.platform_id)

        if Platform.find(import.platform_id).name == 'Shopify'
          ExternalDataImportJob.set(wait: 10.seconds).perform_later(import.app_id, api,
                                                                    { start: (import.start_time - 1.days).to_s, end: import.start_time.to_s }, 'user', '')
          ExternalDataImportJob.set(wait: 20.seconds).perform_later(import.app_id, api,
                                                                    { start: (import.start_time - 1.days).to_s, end: import.start_time.to_s }, 'daily_finance', '')
          ExternalDataImportJob.set(wait: 30.seconds).perform_later(import.app_id, api,
                                                                    { start: (import.start_time - 30.days).to_s, end: import.start_time.to_s }, 'monthly_finance', '')
        end

        render json: params
      end
    end
  end
end

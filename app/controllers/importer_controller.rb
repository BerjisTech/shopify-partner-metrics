# frozen_string_literal: true

class ImporterController < ApplicationController
  respond_to :json, only: :shopify_test

  PLATFORM = Platform.find_by(name: 'Shopify').id

  def shopify
    start = params[:start].to_i.nil? ? params[:data_set] : 1
    render json: ShopifyImport.start_importer(params[:app_id], api,
                                              { start: (DateTime.now - start.days).to_s, end: DateTime.now.to_s }, params[:data_set], '')

    # monthly_metrics = ExternalMetric.where(app_id: App.first.id, platform_id: Platform.find_by(name: 'Shopify').id).where(
    #   'date > ?', 30.days.ago
    # ).pluck('SUM(new_users) as new_users, SUM(lost_users) as lost_users, SUM(deactivations) as deactivations, SUM(reactivations) as reactivations')
    # render json: monthly_metrics.first.first
  end

  def shopify_test
    app = App.find(params[:app_id])
    not_found = {
      current_app_path: edit_app_path(app.id),
      current_api_path: edit_third_party_api_path(api.id),
      status: true,
      data: [],
      ok: []
    }

    if confirm_api_details(api).nil?
      not_found[:status] = false
    else

      test_results = ShopifyImport.start_importer(app.id, api,
                                                  { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'test', '')
      test_results.map do |t|
        if App.find_by(app_name: t.first).nil?

          not_found[:data] << {
            path: apps_path,
            authenticity_token: form_authenticity_token,
            app: {
              app_name: t.first,
              user_id: current_user.id,
              business_id: Business.mine(current_user.id).first.id,
              platform_id: Platform.find_by(name: 'Shopify').id,
              api_key: api.api_key,
              app_code: api.app_code,
              partner_id: api.partner_id,
              secondary_key: api.secondary_api_key
            }
          }
        else
          app_id = App.find_by(app_name: t.first).id

          ExternalDataImportJob.set(wait: 30.seconds).perform_later(app_id, api, { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'user', '')
          ExternalDataImportJob.set(wait: 30.seconds).perform_later(app_id, api, { start: (DateTime.now - 1.days).to_s, end: DateTime.now.to_s }, 'daily_finance', '')
          ExternalDataImportJob.set(wait: 30.seconds).perform_later(app_id, api, { start: (DateTime.now - 30.days).to_s, end: DateTime.now.to_s }, 'monthly_finance', '')
          
          not_found[:ok] << {
            path: apps_path,
            authenticity_token: form_authenticity_token,
            app_id: app_id,
            app: {
              app_name: t.first,
              user_id: current_user.id,
              business_id: Business.mine(current_user.id).first.id,
              platform_id: Platform.find_by(name: 'Shopify').id,
              api_key: api.api_key,
              app_code: api.app_code,
              partner_id: api.partner_id,
              secondary_key: api.secondary_api_key
            }
          }
        end
      end
    end

    render json: not_found
  end

  def api
    ThirdPartyApi.find_by(app_id: params[:app_id], platform_id: PLATFORM)
  end

  def confirm_api_details(api)
    api.api_key.nil? && api.app_code && api.partner_id
  end
end

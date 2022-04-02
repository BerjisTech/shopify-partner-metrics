# frozen_string_literal: true

class ImporterController < ApplicationController
  def shopify
    # render json: ShopifyImport.start_importer(App.first.id,
    #                                           { start: (DateTime.now - 30.days).to_s, end: DateTime.now.to_s }, params[:data_set], '')

    monthly_metrics = ExternalMetric.where(app_id: App.first.id, platform_id: Platform.find_by(name: 'Shopify').id).where(
      'date > ?', 30.days.ago
    ).pluck('SUM(new_users) as new_users, SUM(lost_users) as lost_users, SUM(deactivations) as deactivations, SUM(reactivations) as reactivations')
    render json: monthly_metrics.first.first
  end
end

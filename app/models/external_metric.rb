# frozen_string_literal: true

class ExternalMetric < ApplicationRecord
  belongs_to :app
  belongs_to :platform

  class << self
    def start_shopify(app_id); end

    def start_stripe(app_id); end

    def recent_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(:gross).select_all
    end

    def recent_monthly_metrics(user_id)
      joins(app: :app_teams).where('app_teams.user_id': user_id).order(:gross).select_all
    end
  end
end

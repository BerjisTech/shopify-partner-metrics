# frozen_string_literal: true

require 'zip'
require 'csv'

class FileFormat < ApplicationRecord
  class << self
    def unzip_file(file)
      csv_file = Tempfile.new(['extracted', '.csv'], 'tmp')
      Zip.on_exists_proc = true
      Zip.continue_on_exists_proc = true
      Zip::File.open(file.path) do |zip_file|
        zip_file.each do |entry|
          entry.extract(csv_file)
        end
      end
      csv_file
    end

    def extract_data(csv_file, user_id)
      table = CSV.parse(File.read(csv_file))
      ShopifyCsvImportJob.set(wait: 10.seconds).perform_later(table.drop(1), user_id)
      table.drop(1).group_by { |t| t[12] }
    end

    def payment_history(data, user_id)
      data.each do |app|
        PaymentHistory.create!(
          payout_period: app[0],
          payment_date: app[1],
          shop: app[2],
          shop_country: app[3],
          charge_creation_time: app[4],
          charge_type: app[5],
          category: app[6],
          partner_sale: app[7].to_f,
          shopify_fee: app[8].to_f,
          processing_fee: app[9].to_f,
          regulatory_operating_fee: app[10].to_f,
          partner_share: app[11].to_f,
          app_title: app[12],
          theme_name: app[13],
          tax_description: app[14],
          charge_id: app[15],
          app_id: App.where(app_name: app[12]).joins('INNER JOIN app_teams on app_teams.app_id = apps.id').where('app_teams.user_id': user_id).pluck('apps.id').first
        )
      end
      data.group_by { |t| t[12] }.each_key { |app_id| PaymentHistory.calculate_initial_metrics(app_id) }
    end

    def create_app(app_name, user_id)
      business_id = Business.mine(user_id).first.id

      app = App.create!({
                          app_name: app_name,
                          platform_id: Platform.find_by(name: 'Shopify').id,
                          business_id: business_id,
                          user_id: user_id
                        })

      AppTeam.create({ user_id: user_id, added_by: user_id, app_id: app.id, business_id: business_id })
    end
  end
end

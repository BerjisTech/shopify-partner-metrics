# frozen_string_literal: true

class ShopifyCsvImportJob < ApplicationJob
  queue_as :default

  def perform(data, user_id)
    FileFormat.payment_history(data, user_id)
  end
end

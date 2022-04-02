# frozen_string_literal: true

class ImporterController < ApplicationController
  def shopify
    render json: ShopifyImport.start_importer(App.first.id,
                                              { start: (DateTime.now - 7.days).to_s, end: DateTime.now.to_s }, params[:data_set])
  end
end

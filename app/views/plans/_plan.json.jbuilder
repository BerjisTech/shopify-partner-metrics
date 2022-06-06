# frozen_string_literal: true

json.extract! plan, :id, :name, :has_exports, :has_breakdown, :price, :has_csv_import, :created_at, :updated_at
json.url plan_url(plan, format: :json)

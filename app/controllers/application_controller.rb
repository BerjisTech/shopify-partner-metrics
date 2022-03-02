# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.implicit_order_column = 'created_at'
end

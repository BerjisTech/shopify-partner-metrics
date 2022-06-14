# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  respond_to :json
  respond_to :html

  private

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    reset_session
    root_path
    # request.referrer || root_path
  end
end

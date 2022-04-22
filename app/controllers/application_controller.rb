# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    new_confirmation_path(resource)
  end

  def after_sign_out_path_for(_resource_or_scope)
    reset_session
    request.referrer || root_path
  end
end

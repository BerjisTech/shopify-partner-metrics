# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(_resource)
    '/confirmation/new'
  end

  def after_sign_up_path_for(_resource)
    '/confirmation/new'
  end
end

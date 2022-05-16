# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # render json: new_user_confirmation_path # new_user_session_path

    # render partial: 'shared/mail'
  end

  def about; end

  def pricing; end

  def faq; end

  def api; end
end

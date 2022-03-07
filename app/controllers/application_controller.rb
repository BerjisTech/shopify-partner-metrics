# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def verify_email
    user = OpenStruct.new params[:user]
    username = user.username.to_s

    validity = if username.length < 4
                 'nope'
               else
                 User.find_by(email: username)
               end
    render json: {
      validity: validity,
      valid: '<span class="material-icons user-good px-2 text-success">done</span>',
      not_valid: '<span class="material-icons user-good px-2 text-danger">cancel</span>'
    }
  end
end

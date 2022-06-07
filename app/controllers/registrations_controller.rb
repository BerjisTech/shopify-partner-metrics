# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(_resource)
    Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'

    email = params[:user][:email]
    customer = Stripe::Customer.create(
      email: email
    )
    User.where(email: email).update_all(customer_id: customer['id'])
    '/confirmation/new'
  end

  def after_sign_up_path_for(_resource)
    '/confirmation/new'
  end
end

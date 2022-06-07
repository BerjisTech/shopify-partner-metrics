# frozen_string_literal: true

class AccountController < ApplicationController
  before_action :set_account
  def index; end

  def set_account
    @account = User.find(current_user.id)
    create_customer_if_none_exists
  end

  def create_customer_if_none_exists
    if @account.customer_id.blank?
      Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'

      customer = Stripe::Customer.create(
        email: current_user.email
      )
      User.where(id: current_user.id).update_all(customer_id: customer['id'])
    end
  end
end

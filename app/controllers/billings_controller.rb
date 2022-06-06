# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  def index
    @billings = Billing.all
  end

  def show; end

  def to_stripe
    Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'

    content_type 'application/json'

    session = Stripe::Checkout::Session.create({
                                                 line_items: [{
                                                   # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
                                                   price: '{{PRICE_ID}}',
                                                   quantity: 1
                                                 }],
                                                 mode: 'payment',
                                                 success_url: "#{root_url}/success.html",
                                                 cancel_url: "#{root_url}/cancel.html"
                                               })
    redirect session.url, 303
  end

  private

  def set_bill
    @bill = Billing.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(:app_id, :user_id, :business_id, :amount, :plan_id)
  end
end

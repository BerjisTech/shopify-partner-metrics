# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  before_action :set_stripe
  def index
    @billings = Billing.all
  end

  def show; end

  def billing; end

  def stripe_subscribe
    subscription = Stripe::Subscription.create({
                                                 customer: params[:customer_id],
                                                 items: [{ price: 'price_CZB2krKbBDOkTS' }]
                                               })
  end

  def stripe_portal
    session = Stripe::BillingPortal::Session.create({
                                                      customer: params[:customer_id],
                                                      return_url: "#{root_url}account"
                                                    })

    redirect_to session.url
  end

  def success; end

  def cancel; end

  private

  def set_stripe
    Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'
  end

  def set_bill
    @bill = Billing.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(:app_id, :user_id, :business_id, :amount, :plan_id)
  end
end

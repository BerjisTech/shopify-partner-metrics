# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  before_action :set_stripe

  def index
    @billings = Billing.all
  end

  def show; end

  def billing; end

  def downgrade_batch; end
  def downgrade; end

  def upgrade_batch; end
  def upgrade; end

  def pay_all; end
  def pay; end

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

  def stripe_session
    head :not_acceptable unless params['_json'] || request.body.read.blank?

    session = Stripe::Checkout::Session.create({
                                                 line_items: [{
                                                   price: Plan.find_by(name: 'Free').price_id, # Provide the exact Price ID (e.g. pr_1234) of the product you want to sell
                                                   quantity: 1
                                                 }],
                                                 mode: 'subscription', # or payment
                                                 success_url: stripe_success_url,
                                                 cancel_url: stripe_cancel_url
                                               })
    redirect_to session.url
  end

  def success
    render json: 'Success'
  end

  def cancel
    render json: 'Cancel'
  end

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

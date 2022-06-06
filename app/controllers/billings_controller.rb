# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  def index
    @billings = Billing.all
  end

  def show; end

  def to_stripe
    subscription = Stripe::Subscription.create({
                                                 customer: params[:customer_id],
                                                 items: [{ price: 'price_CZB2krKbBDOkTS' }]
                                               })

    redirect session.url, 303
  end

  def success; end

  def cancel; end

  private

  def set_bill
    @bill = Billing.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(:app_id, :user_id, :business_id, :amount, :plan_id)
  end
end

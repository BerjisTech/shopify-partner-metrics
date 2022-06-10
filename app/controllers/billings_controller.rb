# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  before_action :set_stripe
  before_action :set_my_apps

  FREE_PLAN = Plan.find_by(name: 'Free').id

  def index
    @billings = Billing.all
  end

  def show; end

  def change_plan
    plan_ids = [params[:current_plan], params[:new_plan]]
    plans = Plan.where(id: [plan_ids])
    @current_plan = plans.filter { |f| f.id == params[:current_plan] }.first
    @new_plan = plans.filter { |f| f.id == params[:new_plan] }.first
  end

  def update_plan; end

  def billing
    @plans = Plan.where(visible: true)
    @free_plan = @plans.filter { |f| f.name == 'Free' }.first.id
  end

  def downgrade_batch
    batch_apps = App.mine(current_user.id).filter { |f| params[:apps].include? f.id }
    render json: batch_apps
  end

  def downgrade; end

  def upgrade_batch
    batch_apps = App.mine(current_user.id).filter { |f| params[:apps].include? f.id }
    render json: batch_apps
  end

  def upgrade; end

  def pay_batch
    batch_apps = App.mine(current_user.id).filter { |f| params[:apps].include? f.id }
    render json: batch_apps
  end

  def pay_all
    paid_apps = @my_apps.filter { |a| a.current_plan != FREE_PLAN }
    payment_due = paid_apps.filter { |a| a.next_bill_date <= Date.today }
    active_plans = paid_apps.group_by(&:price_id).keys.uniq
    line_items = []
    active_plans.map do |plan|
      line_items << { price: plan, quantity: paid_apps.filter do |f|
                                               f.price_id == plan
                                             end.count }
    end
    stripe_session(line_items, paid_apps)
  end

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

  def stripe_session(line_items, apps)
    head :not_acceptable unless params['_json'] || request.body.read.blank?

    session = Stripe::Checkout::Session.create({
                                                 line_items: [line_items],
                                                 mode: 'payment', # or payment
                                                 success_url: stripe_success_url(apps),
                                                 cancel_url: stripe_cancel_url(apps)
                                               })
    redirect_to session.url
    # render json: line_items
  end

  def stripe_webhook
    endpoint_secret = 'whsec_05b7145c91c72ee27e05dbd5e9d0b6faceea02d025307eabbc1469676da9a0b3'
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
    # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end

    status 200
    render json: [params, request.referer, event, payload]
  end

  def success
    results = params[:apps].split('/')
    render json: results
  end

  def cancel
    render json: params
  end

  private

  def set_stripe
    Stripe.api_key = 'sk_test_51KCeiSR1t9C4RD6OI2oDkdJH5VoN0xYPIS6vtTTYBL2fLi7LdIScU5PpJuzbmQkKkiNtmMdwDwF3snZCVY4aUgwR00r3h3iCsJ'
  end

  def set_my_apps
    @my_apps = App.mine(current_user.id)
  end

  def set_bill
    @bill = Billing.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(:app_id, :user_id, :business_id, :amount, :plan_id)
  end
end

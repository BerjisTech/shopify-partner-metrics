# frozen_string_literal: true

class BillingsController < InheritedResources::Base
  before_action :set_bill, only: %i[show]
  before_action :set_stripe, except: %i[stripe_webhook webhook_json]
  before_action :set_my_apps, except: %i[stripe_webhook webhook_json]
  skip_before_action :verify_authenticity_token, only: :stripe_webhook

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
                                                 mode: 'subscription', # or payment
                                                 success_url: stripe_success_url(apps),
                                                 cancel_url: stripe_cancel_url(apps)
                                               })
    redirect_to session.url
  end

  def stripe_webhook
    endpoint_secret = 'whsec_05b7145c91c72ee27e05dbd5e9d0b6faceea02d025307eabbc1469676da9a0b3'
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
    error = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      head 400
      error = 'Invalid payload'
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      head 400
      error = 'Invalid signature'
      return
    end

    # Handle the event
    if event.present?
      case event.type
      when 'payment_intent.succeeded'
        payment_intent = event.data.object
      # ... handle other event types
      else
        puts "Unhandled event type: #{event.type}"
      end
    end

    head 200
    # render json: { error: error, params: params, request: request.referer }
  end

  def webhook_json
    render json: [
      {"id"=>"evt_3LAVpHR1t9C4RD6O1zDyHKs5", "object"=>"event", "api_version"=>"2020-08-27", "created"=>1655198061, "data"=>{"object"=>{"id"=>"ch_3LAVpHR1t9C4RD6O1IUblZz8", "object"=>"charge", "amount"=>2000, "amount_captured"=>2000, "amount_refunded"=>0, "application"=>nil, "application_fee"=>nil, "application_fee_amount"=>nil, "balance_transaction"=>"txn_3LAVpHR1t9C4RD6O10UXktqi", "billing_details"=>{"address"=>{"city"=>nil, "country"=>nil, "line1"=>nil, "line2"=>nil, "postal_code"=>nil, "state"=>nil}, "email"=>nil, "name"=>nil, "phone"=>nil}, "calculated_statement_descriptor"=>"PRYCELY LLC", "captured"=>true, "created"=>1655198060, "currency"=>"usd", "customer"=>nil, "description"=>"(created by Stripe CLI)", "destination"=>nil, "dispute"=>nil, "disputed"=>false, "failure_balance_transaction"=>nil, "failure_code"=>nil, "failure_message"=>nil, "fraud_details"=>{}, "invoice"=>nil, "livemode"=>false, "metadata"=>{}, "on_behalf_of"=>nil, "order"=>nil, "outcome"=>{"network_status"=>"approved_by_network", "reason"=>nil, "risk_level"=>"normal", "risk_score"=>21, "seller_message"=>"Payment complete.", "type"=>"authorized"}, "paid"=>true, "payment_intent"=>"pi_3LAVpHR1t9C4RD6O19fKFHjW", "payment_method"=>"pm_1LAVpHR1t9C4RD6O4Ptt1tmP", "payment_method_details"=>{"card"=>{"brand"=>"visa", "checks"=>{"address_line1_check"=>nil, "address_postal_code_check"=>nil, "cvc_check"=>nil}, "country"=>"US", "exp_month"=>6, "exp_year"=>2023, "fingerprint"=>"1hIusmRMCPsPIwMy", "funding"=>"credit", "installments"=>nil, "last4"=>"4242", "mandate"=>nil, "network"=>"visa", "three_d_secure"=>nil, "wallet"=>nil}, "type"=>"card"}, "receipt_email"=>nil, "receipt_number"=>nil, "receipt_url"=>"https://pay.stripe.com/receipts/acct_1KCeiSR1t9C4RD6O/ch_3LAVpHR1t9C4RD6O1IUblZz8/rcpt_LsGMSCkPQuRiwVrNKpevuchHRzYV00A", "refunded"=>false, "refunds"=>{"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/charges/ch_3LAVpHR1t9C4RD6O1IUblZz8/refunds"}, "review"=>nil, "shipping"=>{"address"=>{"city"=>"San Francisco", "country"=>"US", "line1"=>"510 Townsend St", "line2"=>nil, "postal_code"=>"94103", "state"=>"CA"}, "carrier"=>nil, "name"=>"Jenny Rosen", "phone"=>nil, "tracking_number"=>nil}, "source"=>nil, "source_transfer"=>nil, "statement_descriptor"=>nil, "statement_descriptor_suffix"=>nil, "status"=>"succeeded", "transfer_data"=>nil, "transfer_group"=>nil}}, "livemode"=>false, "pending_webhooks"=>2, "request"=>{"id"=>"req_U83IoBn0mli4VE", "idempotency_key"=>"[FILTERED]"}, "type"=>"charge.succeeded", "billing"=>{"id"=>"evt_3LAVpHR1t9C4RD6O1zDyHKs5"}},
      {"id"=>"evt_3LAVpHR1t9C4RD6O1cLTGnhk", "object"=>"event", "api_version"=>"2020-08-27", "created"=>1655198061, "data"=>{"object"=>{"id"=>"pi_3LAVpHR1t9C4RD6O19fKFHjW", "object"=>"payment_intent", "amount"=>2000, "amount_capturable"=>0, "amount_details"=>{"tip"=>{}}, "amount_received"=>2000, "application"=>nil, "application_fee_amount"=>nil, "automatic_payment_methods"=>nil, "canceled_at"=>nil, "cancellation_reason"=>nil, "capture_method"=>"automatic", "charges"=>{"object"=>"list", "data"=>[{"id"=>"ch_3LAVpHR1t9C4RD6O1IUblZz8", "object"=>"charge", "amount"=>2000, "amount_captured"=>2000, "amount_refunded"=>0, "application"=>nil, "application_fee"=>nil, "application_fee_amount"=>nil, "balance_transaction"=>"txn_3LAVpHR1t9C4RD6O10UXktqi", "billing_details"=>{"address"=>{"city"=>nil, "country"=>nil, "line1"=>nil, "line2"=>nil, "postal_code"=>nil, "state"=>nil}, "email"=>nil, "name"=>nil, "phone"=>nil}, "calculated_statement_descriptor"=>"PRYCELY LLC", "captured"=>true, "created"=>1655198060, "currency"=>"usd", "customer"=>nil, "description"=>"(created by Stripe CLI)", "destination"=>nil, "dispute"=>nil, "disputed"=>false, "failure_balance_transaction"=>nil, "failure_code"=>nil, "failure_message"=>nil, "fraud_details"=>{}, "invoice"=>nil, "livemode"=>false, "metadata"=>{}, "on_behalf_of"=>nil, "order"=>nil, "outcome"=>{"network_status"=>"approved_by_network", "reason"=>nil, "risk_level"=>"normal", "risk_score"=>21, "seller_message"=>"Payment complete.", "type"=>"authorized"}, "paid"=>true, "payment_intent"=>"pi_3LAVpHR1t9C4RD6O19fKFHjW", "payment_method"=>"pm_1LAVpHR1t9C4RD6O4Ptt1tmP", "payment_method_details"=>{"card"=>{"brand"=>"visa", "checks"=>{"address_line1_check"=>nil, "address_postal_code_check"=>nil, "cvc_check"=>nil}, "country"=>"US", "exp_month"=>6, "exp_year"=>2023, "fingerprint"=>"1hIusmRMCPsPIwMy", "funding"=>"credit", "installments"=>nil, "last4"=>"4242", "mandate"=>nil, "network"=>"visa", "three_d_secure"=>nil, "wallet"=>nil}, "type"=>"card"}, "receipt_email"=>nil, "receipt_number"=>nil, "receipt_url"=>"https://pay.stripe.com/receipts/acct_1KCeiSR1t9C4RD6O/ch_3LAVpHR1t9C4RD6O1IUblZz8/rcpt_LsGMSCkPQuRiwVrNKpevuchHRzYV00A", "refunded"=>false, "refunds"=>{"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/charges/ch_3LAVpHR1t9C4RD6O1IUblZz8/refunds"}, "review"=>nil, "shipping"=>{"address"=>{"city"=>"San Francisco", "country"=>"US", "line1"=>"510 Townsend St", "line2"=>nil, "postal_code"=>"94103", "state"=>"CA"}, "carrier"=>nil, "name"=>"Jenny Rosen", "phone"=>nil, "tracking_number"=>nil}, "source"=>nil, "source_transfer"=>nil, "statement_descriptor"=>nil, "statement_descriptor_suffix"=>nil, "status"=>"succeeded", "transfer_data"=>nil, "transfer_group"=>nil}], "has_more"=>false, "total_count"=>1, "url"=>"/v1/charges?payment_intent=pi_3LAVpHR1t9C4RD6O19fKFHjW"}, "client_secret"=>"[FILTERED]", "confirmation_method"=>"automatic", "created"=>1655198059, "currency"=>"usd", "customer"=>nil, "description"=>"(created by Stripe CLI)", "invoice"=>nil, "last_payment_error"=>nil, "livemode"=>false, "metadata"=>{}, "next_action"=>nil, "on_behalf_of"=>nil, "payment_method"=>"pm_1LAVpHR1t9C4RD6O4Ptt1tmP", "payment_method_options"=>{"card"=>{"installments"=>nil, "mandate_options"=>nil, "network"=>nil, "request_three_d_secure"=>"automatic"}}, "payment_method_types"=>["card"], "processing"=>nil, "receipt_email"=>nil, "review"=>nil, "setup_future_usage"=>nil, "shipping"=>{"address"=>{"city"=>"San Francisco", "country"=>"US", "line1"=>"510 Townsend St", "line2"=>nil, "postal_code"=>"94103", "state"=>"CA"}, "carrier"=>nil, "name"=>"Jenny Rosen", "phone"=>nil, "tracking_number"=>nil}, "source"=>nil, "statement_descriptor"=>nil, "statement_descriptor_suffix"=>nil, "status"=>"succeeded", "transfer_data"=>nil, "transfer_group"=>nil}}, "livemode"=>false, "pending_webhooks"=>2, "request"=>{"id"=>"req_U83IoBn0mli4VE", "idempotency_key"=>"[FILTERED]"}, "type"=>"payment_intent.succeeded", "billing"=>{"id"=>"evt_3LAVpHR1t9C4RD6O1cLTGnhk"}},
      {"id"=>"evt_3LAVpHR1t9C4RD6O1b6o9PvM", "object"=>"event", "api_version"=>"2020-08-27", "created"=>1655198059, "data"=>{"object"=>{"id"=>"pi_3LAVpHR1t9C4RD6O19fKFHjW", "object"=>"payment_intent", "amount"=>2000, "amount_capturable"=>0, "amount_details"=>{"tip"=>{}}, "amount_received"=>0, "application"=>nil, "application_fee_amount"=>nil, "automatic_payment_methods"=>nil, "canceled_at"=>nil, "cancellation_reason"=>nil, "capture_method"=>"automatic", "charges"=>{"object"=>"list", "data"=>[], "has_more"=>false, "total_count"=>0, "url"=>"/v1/charges?payment_intent=pi_3LAVpHR1t9C4RD6O19fKFHjW"}, "client_secret"=>"[FILTERED]", "confirmation_method"=>"automatic", "created"=>1655198059, "currency"=>"usd", "customer"=>nil, "description"=>"(created by Stripe CLI)", "invoice"=>nil, "last_payment_error"=>nil, "livemode"=>false, "metadata"=>{}, "next_action"=>nil, "on_behalf_of"=>nil, "payment_method"=>nil, "payment_method_options"=>{"card"=>{"installments"=>nil, "mandate_options"=>nil, "network"=>nil, "request_three_d_secure"=>"automatic"}}, "payment_method_types"=>["card"], "processing"=>nil, "receipt_email"=>nil, "review"=>nil, "setup_future_usage"=>nil, "shipping"=>{"address"=>{"city"=>"San Francisco", "country"=>"US", "line1"=>"510 Townsend St", "line2"=>nil, "postal_code"=>"94103", "state"=>"CA"}, "carrier"=>nil, "name"=>"Jenny Rosen", "phone"=>nil, "tracking_number"=>nil}, "source"=>nil, "statement_descriptor"=>nil, "statement_descriptor_suffix"=>nil, "status"=>"requires_payment_method", "transfer_data"=>nil, "transfer_group"=>nil}}, "livemode"=>false, "pending_webhooks"=>2, "request"=>{"id"=>"req_U83IoBn0mli4VE", "idempotency_key"=>"[FILTERED]"}, "type"=>"payment_intent.created", "billing"=>{"id"=>"evt_3LAVpHR1t9C4RD6O1b6o9PvM"}}
    ]
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

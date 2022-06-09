# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_06_09_095749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "app_plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.text "plan_name"
    t.float "plan_price"
    t.float "plan_trial_price"
    t.integer "trial_days"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "app_teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "business_id"
    t.uuid "app_id"
    t.uuid "user_id"
    t.uuid "added_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
  end

  create_table "apps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "app_name"
    t.uuid "user_id"
    t.uuid "platform_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "business_id"
    t.text "app_url"
    t.text "running_data_endpoint"
    t.integer "data_rounds"
    t.uuid "current_plan"
  end

  create_table "billings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.uuid "user_id"
    t.uuid "business_id"
    t.float "amount"
    t.uuid "plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "businesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "business_name"
    t.uuid "user_id"
    t.uuid "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "docs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "topic"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "requests"
    t.uuid "docs_category_id"
    t.index ["description"], name: "index_docs_on_description"
    t.index ["topic"], name: "index_docs_on_topic"
  end

  create_table "docs_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_docs_categories_on_name"
  end

  create_table "error_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "activity"
    t.text "message"
    t.text "logs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "external_metrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.float "gross"
    t.float "net"
    t.float "trial"
    t.integer "paying_users"
    t.integer "trial_users"
    t.integer "new_users"
    t.integer "lost_users"
    t.float "mrr_chrun"
    t.float "user_churn"
    t.float "arpu"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "platform_id"
    t.integer "deactivations"
    t.integer "reactivations"
    t.datetime "date"
    t.float "recurring_revenue"
    t.float "one_time_charge"
    t.float "refunds"
    t.float "arr"
    t.string "app_name"
  end

  create_table "import_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "platform_id"
    t.uuid "app_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "industries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invite_accepts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "invite_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "business_id"
    t.uuid "recepient"
    t.uuid "sender"
    t.integer "limit"
    t.integer "accepts"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "payout_period"
    t.datetime "payment_date"
    t.string "shop"
    t.string "shop_country"
    t.datetime "charge_creation_time"
    t.text "charge_type"
    t.string "category"
    t.float "partner_sale"
    t.float "shopify_fee"
    t.float "processing_fee"
    t.float "regulatory_operating_fee"
    t.float "partner_share"
    t.text "app_title"
    t.string "theme_name"
    t.string "tax_description"
    t.string "charge_id"
    t.uuid "app_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_date"], name: "index_payment_histories_on_payment_date"
  end

  create_table "plan_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.uuid "plan_id"
    t.integer "plan_paying_users"
    t.integer "plan_trial_users"
    t.integer "plan_total_users"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "has_exports"
    t.boolean "has_breakdown"
    t.float "price"
    t.boolean "has_csv_import"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "price_id"
    t.index ["has_breakdown"], name: "index_plans_on_has_breakdown"
    t.index ["has_csv_import"], name: "index_plans_on_has_csv_import"
    t.index ["has_exports"], name: "index_plans_on_has_exports"
    t.index ["name"], name: "index_plans_on_name"
  end

  create_table "platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "running_data", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.float "gross_paying_mrr"
    t.float "gross_trial_mrr"
    t.integer "gross_paying_users"
    t.integer "gross_trial_users"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "app_id"
  end

  create_table "running_data_endpoints", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.text "endpoint"
    t.integer "data_rounds"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "running_metrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "app_id"
    t.float "gross"
    t.float "trial"
    t.integer "paying_users"
    t.integer "trial_users"
    t.float "mrr_chrun"
    t.float "user_churn"
    t.float "arpu"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
  end

  create_table "shopify_imports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shopify_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shopify_user_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "activity"
    t.uuid "app_id"
    t.datetime "date"
    t.text "shopify_domain"
    t.text "shop_gid"
    t.text "descritpion"
    t.text "reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "platform_id"
    t.index ["activity"], name: "index_shopify_user_activities_on_activity"
    t.index ["app_id"], name: "index_shopify_user_activities_on_app_id"
    t.index ["descritpion"], name: "index_shopify_user_activities_on_descritpion"
    t.index ["reason"], name: "index_shopify_user_activities_on_reason"
    t.index ["shopify_domain"], name: "index_shopify_user_activities_on_shopify_domain"
  end

  create_table "shopify_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "staffs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "business_id"
    t.uuid "user_id"
    t.integer "status"
    t.integer "designation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stripe_imports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "third_party_apis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "platform_id"
    t.text "api_key"
    t.text "api_secret"
    t.text "secondary_api_key"
    t.text "secondary_api_secret"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "app_id"
    t.string "partner_id"
    t.string "app_code"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "integer_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.text "first_name"
    t.text "last_name"
    t.string "username"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "customer_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

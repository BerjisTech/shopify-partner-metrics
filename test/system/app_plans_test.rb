require "application_system_test_case"

class AppPlansTest < ApplicationSystemTestCase
  setup do
    @app_plan = app_plans(:one)
  end

  test "visiting the index" do
    visit app_plans_url
    assert_selector "h1", text: "App Plans"
  end

  test "creating a App plan" do
    visit app_plans_url
    click_on "New App Plan"

    fill_in "App", with: @app_plan.app_id
    fill_in "Plan name", with: @app_plan.plan_name
    fill_in "Plan price", with: @app_plan.plan_price
    fill_in "Plan trial price", with: @app_plan.plan_trial_price
    fill_in "Trial days", with: @app_plan.trial_days
    click_on "Create App plan"

    assert_text "App plan was successfully created"
    click_on "Back"
  end

  test "updating a App plan" do
    visit app_plans_url
    click_on "Edit", match: :first

    fill_in "App", with: @app_plan.app_id
    fill_in "Plan name", with: @app_plan.plan_name
    fill_in "Plan price", with: @app_plan.plan_price
    fill_in "Plan trial price", with: @app_plan.plan_trial_price
    fill_in "Trial days", with: @app_plan.trial_days
    click_on "Update App plan"

    assert_text "App plan was successfully updated"
    click_on "Back"
  end

  test "destroying a App plan" do
    visit app_plans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App plan was successfully destroyed"
  end
end

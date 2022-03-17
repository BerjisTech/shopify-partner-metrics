require "application_system_test_case"

class PlanDataTest < ApplicationSystemTestCase
  setup do
    @plan_datum = plan_data(:one)
  end

  test "visiting the index" do
    visit plan_data_url
    assert_selector "h1", text: "Plan Data"
  end

  test "creating a Plan datum" do
    visit plan_data_url
    click_on "New Plan Datum"

    fill_in "App", with: @plan_datum.app_id
    fill_in "Plan", with: @plan_datum.plan_id
    fill_in "Plan paying users", with: @plan_datum.plan_paying_users
    fill_in "Plan total users", with: @plan_datum.plan_total_users
    fill_in "Plan trial users", with: @plan_datum.plan_trial_users
    click_on "Create Plan datum"

    assert_text "Plan datum was successfully created"
    click_on "Back"
  end

  test "updating a Plan datum" do
    visit plan_data_url
    click_on "Edit", match: :first

    fill_in "App", with: @plan_datum.app_id
    fill_in "Plan", with: @plan_datum.plan_id
    fill_in "Plan paying users", with: @plan_datum.plan_paying_users
    fill_in "Plan total users", with: @plan_datum.plan_total_users
    fill_in "Plan trial users", with: @plan_datum.plan_trial_users
    click_on "Update Plan datum"

    assert_text "Plan datum was successfully updated"
    click_on "Back"
  end

  test "destroying a Plan datum" do
    visit plan_data_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plan datum was successfully destroyed"
  end
end

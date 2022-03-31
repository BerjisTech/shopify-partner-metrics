require "application_system_test_case"

class RunningMetricsTest < ApplicationSystemTestCase
  setup do
    @running_metric = running_metrics(:one)
  end

  test "visiting the index" do
    visit running_metrics_url
    assert_selector "h1", text: "Running Metrics"
  end

  test "creating a Running metric" do
    visit running_metrics_url
    click_on "New Running Metric"

    fill_in "App", with: @running_metric.app_id
    fill_in "Arpu", with: @running_metric.arpu
    fill_in "Gross", with: @running_metric.gross
    fill_in "Mrr chrun", with: @running_metric.mrr_chrun
    fill_in "Paying users", with: @running_metric.paying_users
    fill_in "Trial", with: @running_metric.trial
    fill_in "Trial users", with: @running_metric.trial_users
    fill_in "User churn", with: @running_metric.user_churn
    click_on "Create Running metric"

    assert_text "Running metric was successfully created"
    click_on "Back"
  end

  test "updating a Running metric" do
    visit running_metrics_url
    click_on "Edit", match: :first

    fill_in "App", with: @running_metric.app_id
    fill_in "Arpu", with: @running_metric.arpu
    fill_in "Gross", with: @running_metric.gross
    fill_in "Mrr chrun", with: @running_metric.mrr_chrun
    fill_in "Paying users", with: @running_metric.paying_users
    fill_in "Trial", with: @running_metric.trial
    fill_in "Trial users", with: @running_metric.trial_users
    fill_in "User churn", with: @running_metric.user_churn
    click_on "Update Running metric"

    assert_text "Running metric was successfully updated"
    click_on "Back"
  end

  test "destroying a Running metric" do
    visit running_metrics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Running metric was successfully destroyed"
  end
end

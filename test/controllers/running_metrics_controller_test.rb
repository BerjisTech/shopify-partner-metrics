require "test_helper"

class RunningMetricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @running_metric = running_metrics(:one)
  end

  test "should get index" do
    get running_metrics_url
    assert_response :success
  end

  test "should get new" do
    get new_running_metric_url
    assert_response :success
  end

  test "should create running_metric" do
    assert_difference('RunningMetric.count') do
      post running_metrics_url, params: { running_metric: { app_id: @running_metric.app_id, arpu: @running_metric.arpu, gross: @running_metric.gross, mrr_chrun: @running_metric.mrr_chrun, paying_users: @running_metric.paying_users, trial: @running_metric.trial, trial_users: @running_metric.trial_users, user_churn: @running_metric.user_churn } }
    end

    assert_redirected_to running_metric_url(RunningMetric.last)
  end

  test "should show running_metric" do
    get running_metric_url(@running_metric)
    assert_response :success
  end

  test "should get edit" do
    get edit_running_metric_url(@running_metric)
    assert_response :success
  end

  test "should update running_metric" do
    patch running_metric_url(@running_metric), params: { running_metric: { app_id: @running_metric.app_id, arpu: @running_metric.arpu, gross: @running_metric.gross, mrr_chrun: @running_metric.mrr_chrun, paying_users: @running_metric.paying_users, trial: @running_metric.trial, trial_users: @running_metric.trial_users, user_churn: @running_metric.user_churn } }
    assert_redirected_to running_metric_url(@running_metric)
  end

  test "should destroy running_metric" do
    assert_difference('RunningMetric.count', -1) do
      delete running_metric_url(@running_metric)
    end

    assert_redirected_to running_metrics_url
  end
end

# frozen_string_literal: true

require 'test_helper'

class ExternalMetricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @external_metric = external_metrics(:one)
  end

  test 'should get index' do
    get external_metrics_url
    assert_response :success
  end

  test 'should get new' do
    get new_external_metric_url
    assert_response :success
  end

  test 'should create external_metric' do
    assert_difference('ExternalMetric.count') do
      post external_metrics_url,
           params: { external_metric: { app_id: @external_metric.app_id, arpu: @external_metric.arpu,
                                        gross: @external_metric.gross, lost_users: @external_metric.lost_users, mrr_chrun: @external_metric.mrr_chrun, net: @external_metric.net, new_users: @external_metric.new_users, paying_users: @external_metric.paying_users, trial: @external_metric.trial, trial_users: @external_metric.trial_users, user_churn: @external_metric.user_churn } }
    end

    assert_redirected_to external_metric_url(ExternalMetric.last)
  end

  test 'should show external_metric' do
    get external_metric_url(@external_metric)
    assert_response :success
  end

  test 'should get edit' do
    get edit_external_metric_url(@external_metric)
    assert_response :success
  end

  test 'should update external_metric' do
    patch external_metric_url(@external_metric),
          params: { external_metric: { app_id: @external_metric.app_id, arpu: @external_metric.arpu,
                                       gross: @external_metric.gross, lost_users: @external_metric.lost_users, mrr_chrun: @external_metric.mrr_chrun, net: @external_metric.net, new_users: @external_metric.new_users, paying_users: @external_metric.paying_users, trial: @external_metric.trial, trial_users: @external_metric.trial_users, user_churn: @external_metric.user_churn } }
    assert_redirected_to external_metric_url(@external_metric)
  end

  test 'should destroy external_metric' do
    assert_difference('ExternalMetric.count', -1) do
      delete external_metric_url(@external_metric)
    end

    assert_redirected_to external_metrics_url
  end
end

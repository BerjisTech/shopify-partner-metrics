# frozen_string_literal: true

require 'test_helper'

class RunningDataEndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @running_data_endpoint = running_data_endpoints(:one)
  end

  test 'should get index' do
    get running_data_endpoints_url
    assert_response :success
  end

  test 'should get new' do
    get new_running_data_endpoint_url
    assert_response :success
  end

  test 'should create running_data_endpoint' do
    assert_difference('RunningDataEndpoint.count') do
      post running_data_endpoints_url,
           params: { running_data_endpoint: { app_id: @running_data_endpoint.app_id,
                                              data_rounds: @running_data_endpoint.data_rounds, endpoint: @running_data_endpoint.endpoint } }
    end

    assert_redirected_to running_data_endpoint_url(RunningDataEndpoint.last)
  end

  test 'should show running_data_endpoint' do
    get running_data_endpoint_url(@running_data_endpoint)
    assert_response :success
  end

  test 'should get edit' do
    get edit_running_data_endpoint_url(@running_data_endpoint)
    assert_response :success
  end

  test 'should update running_data_endpoint' do
    patch running_data_endpoint_url(@running_data_endpoint),
          params: { running_data_endpoint: { app_id: @running_data_endpoint.app_id,
                                             data_rounds: @running_data_endpoint.data_rounds, endpoint: @running_data_endpoint.endpoint } }
    assert_redirected_to running_data_endpoint_url(@running_data_endpoint)
  end

  test 'should destroy running_data_endpoint' do
    assert_difference('RunningDataEndpoint.count', -1) do
      delete running_data_endpoint_url(@running_data_endpoint)
    end

    assert_redirected_to running_data_endpoints_url
  end
end

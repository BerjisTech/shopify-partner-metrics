# frozen_string_literal: true

require 'test_helper'

class ThirdPartyApisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @third_party_api = third_party_apis(:one)
  end

  test 'should get index' do
    get third_party_apis_url
    assert_response :success
  end

  test 'should get new' do
    get new_third_party_api_url
    assert_response :success
  end

  test 'should create third_party_api' do
    assert_difference('ThirdPartyApi.count') do
      post third_party_apis_url,
           params: { third_party_api: { api_key: @third_party_api.api_key, api_secret: @third_party_api.api_secret,
                                        platform_id: @third_party_api.platform_id, secondary_api_key: @third_party_api.secondary_api_key, secondary_api_secret: @third_party_api.secondary_api_secret } }
    end

    assert_redirected_to third_party_api_url(ThirdPartyApi.last)
  end

  test 'should show third_party_api' do
    get third_party_api_url(@third_party_api)
    assert_response :success
  end

  test 'should get edit' do
    get edit_third_party_api_url(@third_party_api)
    assert_response :success
  end

  test 'should update third_party_api' do
    patch third_party_api_url(@third_party_api),
          params: { third_party_api: { api_key: @third_party_api.api_key, api_secret: @third_party_api.api_secret,
                                       platform_id: @third_party_api.platform_id, secondary_api_key: @third_party_api.secondary_api_key, secondary_api_secret: @third_party_api.secondary_api_secret } }
    assert_redirected_to third_party_api_url(@third_party_api)
  end

  test 'should destroy third_party_api' do
    assert_difference('ThirdPartyApi.count', -1) do
      delete third_party_api_url(@third_party_api)
    end

    assert_redirected_to third_party_apis_url
  end
end

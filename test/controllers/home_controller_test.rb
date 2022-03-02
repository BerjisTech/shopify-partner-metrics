# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get home_index_url
    assert_response :success
  end

  test 'should get about' do
    get home_about_url
    assert_response :success
  end

  test 'should get pricing' do
    get home_pricing_url
    assert_response :success
  end

  test 'should get faq' do
    get home_faq_url
    assert_response :success
  end

  test 'should get api' do
    get home_api_url
    assert_response :success
  end
end

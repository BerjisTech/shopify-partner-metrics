# frozen_string_literal: true

require 'test_helper'

class AppPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_plan = app_plans(:one)
  end

  test 'should get index' do
    get app_plans_url
    assert_response :success
  end

  test 'should get new' do
    get new_app_plan_url
    assert_response :success
  end

  test 'should create app_plan' do
    assert_difference('AppPlan.count') do
      post app_plans_url,
           params: { app_plan: { app_id: @app_plan.app_id, plan_name: @app_plan.plan_name, plan_price: @app_plan.plan_price,
                                 plan_trial_price: @app_plan.plan_trial_price, trial_days: @app_plan.trial_days } }
    end

    assert_redirected_to app_plan_url(AppPlan.last)
  end

  test 'should show app_plan' do
    get app_plan_url(@app_plan)
    assert_response :success
  end

  test 'should get edit' do
    get edit_app_plan_url(@app_plan)
    assert_response :success
  end

  test 'should update app_plan' do
    patch app_plan_url(@app_plan),
          params: { app_plan: { app_id: @app_plan.app_id, plan_name: @app_plan.plan_name, plan_price: @app_plan.plan_price,
                                plan_trial_price: @app_plan.plan_trial_price, trial_days: @app_plan.trial_days } }
    assert_redirected_to app_plan_url(@app_plan)
  end

  test 'should destroy app_plan' do
    assert_difference('AppPlan.count', -1) do
      delete app_plan_url(@app_plan)
    end

    assert_redirected_to app_plans_url
  end
end

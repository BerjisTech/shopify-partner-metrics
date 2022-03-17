require "test_helper"

class PlanDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan_datum = plan_data(:one)
  end

  test "should get index" do
    get plan_data_url
    assert_response :success
  end

  test "should get new" do
    get new_plan_datum_url
    assert_response :success
  end

  test "should create plan_datum" do
    assert_difference('PlanDatum.count') do
      post plan_data_url, params: { plan_datum: { app_id: @plan_datum.app_id, plan_id: @plan_datum.plan_id, plan_paying_users: @plan_datum.plan_paying_users, plan_total_users: @plan_datum.plan_total_users, plan_trial_users: @plan_datum.plan_trial_users } }
    end

    assert_redirected_to plan_datum_url(PlanDatum.last)
  end

  test "should show plan_datum" do
    get plan_datum_url(@plan_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_datum_url(@plan_datum)
    assert_response :success
  end

  test "should update plan_datum" do
    patch plan_datum_url(@plan_datum), params: { plan_datum: { app_id: @plan_datum.app_id, plan_id: @plan_datum.plan_id, plan_paying_users: @plan_datum.plan_paying_users, plan_total_users: @plan_datum.plan_total_users, plan_trial_users: @plan_datum.plan_trial_users } }
    assert_redirected_to plan_datum_url(@plan_datum)
  end

  test "should destroy plan_datum" do
    assert_difference('PlanDatum.count', -1) do
      delete plan_datum_url(@plan_datum)
    end

    assert_redirected_to plan_data_url
  end
end

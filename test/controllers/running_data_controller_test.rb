require "test_helper"

class RunningDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @running_datum = running_data(:one)
  end

  test "should get index" do
    get running_data_url
    assert_response :success
  end

  test "should get new" do
    get new_running_datum_url
    assert_response :success
  end

  test "should create running_datum" do
    assert_difference('RunningDatum.count') do
      post running_data_url, params: { running_datum: { date: @running_datum.date, gross_paying_mrr: @running_datum.gross_paying_mrr, gross_paying_users: @running_datum.gross_paying_users, gross_trial_mrr: @running_datum.gross_trial_mrr, gross_trial_users: @running_datum.gross_trial_users } }
    end

    assert_redirected_to running_datum_url(RunningDatum.last)
  end

  test "should show running_datum" do
    get running_datum_url(@running_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_running_datum_url(@running_datum)
    assert_response :success
  end

  test "should update running_datum" do
    patch running_datum_url(@running_datum), params: { running_datum: { date: @running_datum.date, gross_paying_mrr: @running_datum.gross_paying_mrr, gross_paying_users: @running_datum.gross_paying_users, gross_trial_mrr: @running_datum.gross_trial_mrr, gross_trial_users: @running_datum.gross_trial_users } }
    assert_redirected_to running_datum_url(@running_datum)
  end

  test "should destroy running_datum" do
    assert_difference('RunningDatum.count', -1) do
      delete running_datum_url(@running_datum)
    end

    assert_redirected_to running_data_url
  end
end

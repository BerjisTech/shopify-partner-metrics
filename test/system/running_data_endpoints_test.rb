require "application_system_test_case"

class RunningDataEndpointsTest < ApplicationSystemTestCase
  setup do
    @running_data_endpoint = running_data_endpoints(:one)
  end

  test "visiting the index" do
    visit running_data_endpoints_url
    assert_selector "h1", text: "Running Data Endpoints"
  end

  test "creating a Running data endpoint" do
    visit running_data_endpoints_url
    click_on "New Running Data Endpoint"

    fill_in "App", with: @running_data_endpoint.app_id
    fill_in "Data rounds", with: @running_data_endpoint.data_rounds
    fill_in "Endpoint", with: @running_data_endpoint.endpoint
    click_on "Create Running data endpoint"

    assert_text "Running data endpoint was successfully created"
    click_on "Back"
  end

  test "updating a Running data endpoint" do
    visit running_data_endpoints_url
    click_on "Edit", match: :first

    fill_in "App", with: @running_data_endpoint.app_id
    fill_in "Data rounds", with: @running_data_endpoint.data_rounds
    fill_in "Endpoint", with: @running_data_endpoint.endpoint
    click_on "Update Running data endpoint"

    assert_text "Running data endpoint was successfully updated"
    click_on "Back"
  end

  test "destroying a Running data endpoint" do
    visit running_data_endpoints_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Running data endpoint was successfully destroyed"
  end
end

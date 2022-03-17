require "application_system_test_case"

class RunningDataTest < ApplicationSystemTestCase
  setup do
    @running_datum = running_data(:one)
  end

  test "visiting the index" do
    visit running_data_url
    assert_selector "h1", text: "Running Data"
  end

  test "creating a Running datum" do
    visit running_data_url
    click_on "New Running Datum"

    fill_in "Date", with: @running_datum.date
    fill_in "Gross paying mrr", with: @running_datum.gross_paying_mrr
    fill_in "Gross paying users", with: @running_datum.gross_paying_users
    fill_in "Gross trial mrr", with: @running_datum.gross_trial_mrr
    fill_in "Gross trial users", with: @running_datum.gross_trial_users
    click_on "Create Running datum"

    assert_text "Running datum was successfully created"
    click_on "Back"
  end

  test "updating a Running datum" do
    visit running_data_url
    click_on "Edit", match: :first

    fill_in "Date", with: @running_datum.date
    fill_in "Gross paying mrr", with: @running_datum.gross_paying_mrr
    fill_in "Gross paying users", with: @running_datum.gross_paying_users
    fill_in "Gross trial mrr", with: @running_datum.gross_trial_mrr
    fill_in "Gross trial users", with: @running_datum.gross_trial_users
    click_on "Update Running datum"

    assert_text "Running datum was successfully updated"
    click_on "Back"
  end

  test "destroying a Running datum" do
    visit running_data_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Running datum was successfully destroyed"
  end
end

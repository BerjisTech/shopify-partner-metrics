require "application_system_test_case"

class AppTeamsTest < ApplicationSystemTestCase
  setup do
    @app_team = app_teams(:one)
  end

  test "visiting the index" do
    visit app_teams_url
    assert_selector "h1", text: "App Teams"
  end

  test "creating a App team" do
    visit app_teams_url
    click_on "New App Team"

    fill_in "Added by", with: @app_team.added_by
    fill_in "App", with: @app_team.app_id
    fill_in "Business", with: @app_team.business_id
    fill_in "User", with: @app_team.user_id
    click_on "Create App team"

    assert_text "App team was successfully created"
    click_on "Back"
  end

  test "updating a App team" do
    visit app_teams_url
    click_on "Edit", match: :first

    fill_in "Added by", with: @app_team.added_by
    fill_in "App", with: @app_team.app_id
    fill_in "Business", with: @app_team.business_id
    fill_in "User", with: @app_team.user_id
    click_on "Update App team"

    assert_text "App team was successfully updated"
    click_on "Back"
  end

  test "destroying a App team" do
    visit app_teams_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App team was successfully destroyed"
  end
end

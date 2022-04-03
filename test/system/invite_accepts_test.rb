require "application_system_test_case"

class InviteAcceptsTest < ApplicationSystemTestCase
  setup do
    @invite_accept = invite_accepts(:one)
  end

  test "visiting the index" do
    visit invite_accepts_url
    assert_selector "h1", text: "Invite Accepts"
  end

  test "creating a Invite accept" do
    visit invite_accepts_url
    click_on "New Invite Accept"

    fill_in "Invite", with: @invite_accept.invite_id
    fill_in "User", with: @invite_accept.user_id
    click_on "Create Invite accept"

    assert_text "Invite accept was successfully created"
    click_on "Back"
  end

  test "updating a Invite accept" do
    visit invite_accepts_url
    click_on "Edit", match: :first

    fill_in "Invite", with: @invite_accept.invite_id
    fill_in "User", with: @invite_accept.user_id
    click_on "Update Invite accept"

    assert_text "Invite accept was successfully updated"
    click_on "Back"
  end

  test "destroying a Invite accept" do
    visit invite_accepts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invite accept was successfully destroyed"
  end
end

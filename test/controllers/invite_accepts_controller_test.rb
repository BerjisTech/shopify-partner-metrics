require "test_helper"

class InviteAcceptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invite_accept = invite_accepts(:one)
  end

  test "should get index" do
    get invite_accepts_url
    assert_response :success
  end

  test "should get new" do
    get new_invite_accept_url
    assert_response :success
  end

  test "should create invite_accept" do
    assert_difference('InviteAccept.count') do
      post invite_accepts_url, params: { invite_accept: { invite_id: @invite_accept.invite_id, user_id: @invite_accept.user_id } }
    end

    assert_redirected_to invite_accept_url(InviteAccept.last)
  end

  test "should show invite_accept" do
    get invite_accept_url(@invite_accept)
    assert_response :success
  end

  test "should get edit" do
    get edit_invite_accept_url(@invite_accept)
    assert_response :success
  end

  test "should update invite_accept" do
    patch invite_accept_url(@invite_accept), params: { invite_accept: { invite_id: @invite_accept.invite_id, user_id: @invite_accept.user_id } }
    assert_redirected_to invite_accept_url(@invite_accept)
  end

  test "should destroy invite_accept" do
    assert_difference('InviteAccept.count', -1) do
      delete invite_accept_url(@invite_accept)
    end

    assert_redirected_to invite_accepts_url
  end
end

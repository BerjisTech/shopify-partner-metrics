# frozen_string_literal: true

require 'test_helper'

class InvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invite = invites(:one)
  end

  test 'should get index' do
    get invites_url
    assert_response :success
  end

  test 'should get new' do
    get new_invite_url
    assert_response :success
  end

  test 'should create invite' do
    assert_difference('Invite.count') do
      post invites_url,
           params: { invite: { accepts: @invite.accepts, business_id: @invite.business_id, limit: @invite.limit,
                               recepient: @invite.recepient, sender: @invite.sender, status: @invite.status } }
    end

    assert_redirected_to invite_url(Invite.last)
  end

  test 'should show invite' do
    get invite_url(@invite)
    assert_response :success
  end

  test 'should get edit' do
    get edit_invite_url(@invite)
    assert_response :success
  end

  test 'should update invite' do
    patch invite_url(@invite),
          params: { invite: { accepts: @invite.accepts, business_id: @invite.business_id, limit: @invite.limit,
                              recepient: @invite.recepient, sender: @invite.sender, status: @invite.status } }
    assert_redirected_to invite_url(@invite)
  end

  test 'should destroy invite' do
    assert_difference('Invite.count', -1) do
      delete invite_url(@invite)
    end

    assert_redirected_to invites_url
  end
end

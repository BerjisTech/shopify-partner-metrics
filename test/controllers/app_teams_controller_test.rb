# frozen_string_literal: true

require 'test_helper'

class AppTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_team = app_teams(:one)
  end

  test 'should get index' do
    get app_teams_url
    assert_response :success
  end

  test 'should get new' do
    get new_app_team_url
    assert_response :success
  end

  test 'should create app_team' do
    assert_difference('AppTeam.count') do
      post app_teams_url,
           params: { app_team: { added_by: @app_team.added_by, app_id: @app_team.app_id, business_id: @app_team.business_id,
                                 user_id: @app_team.user_id } }
    end

    assert_redirected_to app_team_url(AppTeam.last)
  end

  test 'should show app_team' do
    get app_team_url(@app_team)
    assert_response :success
  end

  test 'should get edit' do
    get edit_app_team_url(@app_team)
    assert_response :success
  end

  test 'should update app_team' do
    patch app_team_url(@app_team),
          params: { app_team: { added_by: @app_team.added_by, app_id: @app_team.app_id, business_id: @app_team.business_id,
                                user_id: @app_team.user_id } }
    assert_redirected_to app_team_url(@app_team)
  end

  test 'should destroy app_team' do
    assert_difference('AppTeam.count', -1) do
      delete app_team_url(@app_team)
    end

    assert_redirected_to app_teams_url
  end
end

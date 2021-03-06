# frozen_string_literal: true

require 'application_system_test_case'

class AppsTest < ApplicationSystemTestCase
  setup do
    @app = apps(:one)
  end

  test 'visiting the index' do
    visit apps_url
    assert_selector 'h1', text: 'Apps'
  end

  test 'creating a App' do
    visit apps_url
    click_on 'New App'

    fill_in 'App name', with: @app.app_name
    fill_in 'Platform', with: @app.platform_id
    fill_in 'User', with: @app.user_id
    click_on 'Create App'

    assert_text 'App was successfully created'
    click_on 'Back'
  end

  test 'updating a App' do
    visit apps_url
    click_on 'Edit', match: :first

    fill_in 'App name', with: @app.app_name
    fill_in 'Platform', with: @app.platform_id
    fill_in 'User', with: @app.user_id
    click_on 'Update App'

    assert_text 'App was successfully updated'
    click_on 'Back'
  end

  test 'destroying a App' do
    visit apps_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'App was successfully destroyed'
  end
end

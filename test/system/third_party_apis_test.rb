# frozen_string_literal: true

require 'application_system_test_case'

class ThirdPartyApisTest < ApplicationSystemTestCase
  setup do
    @third_party_api = third_party_apis(:one)
  end

  test 'visiting the index' do
    visit third_party_apis_url
    assert_selector 'h1', text: 'Third Party Apis'
  end

  test 'creating a Third party api' do
    visit third_party_apis_url
    click_on 'New Third Party Api'

    fill_in 'Api key', with: @third_party_api.api_key
    fill_in 'Api secret', with: @third_party_api.api_secret
    fill_in 'Platform', with: @third_party_api.platform_id
    fill_in 'Secondary api key', with: @third_party_api.secondary_api_key
    fill_in 'Secondary api secret', with: @third_party_api.secondary_api_secret
    click_on 'Create Third party api'

    assert_text 'Third party api was successfully created'
    click_on 'Back'
  end

  test 'updating a Third party api' do
    visit third_party_apis_url
    click_on 'Edit', match: :first

    fill_in 'Api key', with: @third_party_api.api_key
    fill_in 'Api secret', with: @third_party_api.api_secret
    fill_in 'Platform', with: @third_party_api.platform_id
    fill_in 'Secondary api key', with: @third_party_api.secondary_api_key
    fill_in 'Secondary api secret', with: @third_party_api.secondary_api_secret
    click_on 'Update Third party api'

    assert_text 'Third party api was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Third party api' do
    visit third_party_apis_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Third party api was successfully destroyed'
  end
end

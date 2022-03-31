# frozen_string_literal: true

require 'application_system_test_case'

class ExternalMetricsTest < ApplicationSystemTestCase
  setup do
    @external_metric = external_metrics(:one)
  end

  test 'visiting the index' do
    visit external_metrics_url
    assert_selector 'h1', text: 'External Metrics'
  end

  test 'creating a External metric' do
    visit external_metrics_url
    click_on 'New External Metric'

    fill_in 'App', with: @external_metric.app_id
    fill_in 'Arpu', with: @external_metric.arpu
    fill_in 'Gross', with: @external_metric.gross
    fill_in 'Lost users', with: @external_metric.lost_users
    fill_in 'Mrr chrun', with: @external_metric.mrr_chrun
    fill_in 'Net', with: @external_metric.net
    fill_in 'New users', with: @external_metric.new_users
    fill_in 'Paying users', with: @external_metric.paying_users
    fill_in 'Trial', with: @external_metric.trial
    fill_in 'Trial users', with: @external_metric.trial_users
    fill_in 'User churn', with: @external_metric.user_churn
    click_on 'Create External metric'

    assert_text 'External metric was successfully created'
    click_on 'Back'
  end

  test 'updating a External metric' do
    visit external_metrics_url
    click_on 'Edit', match: :first

    fill_in 'App', with: @external_metric.app_id
    fill_in 'Arpu', with: @external_metric.arpu
    fill_in 'Gross', with: @external_metric.gross
    fill_in 'Lost users', with: @external_metric.lost_users
    fill_in 'Mrr chrun', with: @external_metric.mrr_chrun
    fill_in 'Net', with: @external_metric.net
    fill_in 'New users', with: @external_metric.new_users
    fill_in 'Paying users', with: @external_metric.paying_users
    fill_in 'Trial', with: @external_metric.trial
    fill_in 'Trial users', with: @external_metric.trial_users
    fill_in 'User churn', with: @external_metric.user_churn
    click_on 'Update External metric'

    assert_text 'External metric was successfully updated'
    click_on 'Back'
  end

  test 'destroying a External metric' do
    visit external_metrics_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'External metric was successfully destroyed'
  end
end

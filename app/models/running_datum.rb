# frozen_string_literal: true

class RunningDatum < ApplicationRecord
  belongs_to :app

  class << self
    def test_endpoint(app_id)
      endpoint = App.find(app_id).running_data_endpoint

      running_data = get_data(endpoint)

      case running_data.status
      when 200
        check_dataset(running_data.body)
      when 404
        'The link provided points to nowhere. Kindly double check to confirm that it is the correct link'
      when 500
        'Something\'s wrong with the data returned. Kindly check that there are no internal errors'
      when 302
        'Something\'s wrong. Kindly check that the link returns a JSON dataset'
      else
        running_data.status
      end
    end

    def check_dataset(data)
      message = ''

      if data['gross_paying_mrr'].present?
        message = "#{message} <code>gross_paying_mrr</code> <br />"
      else
        message = "#{message} We could not find the Gross paying mrr <code>gross_paying_mrr</code>, if you don't have or need this just pass it as 0 or nil<br />"
      end

      if data['gross_trial_mrr'].present?
        message = "#{message} <code>gross_trial_mrr</code> <br />"
      else
        message = "#{message} We could not find the Gross paying mrr <code>gross_trial_mrr</code>, if you don't have or need this just pass it as 0 or nil<br />"
      end

      if data['gross_paying_users'].present?
        message = "#{message} <code>gross_paying_users</code> <br />"
      else
        message = "#{message} We could not find the Gross paying mrr <code>gross_paying_users</code>, if you don't have or need this just pass it as 0 or nil<br />"
      end

      if data['gross_trial_users'].present?
        message = "#{message} <code>gross_trial_users</code> <br />"
      else
        message = "#{message} We could not find the Gross paying mrr <code>gross_trial_users</code>, if you don't have or need this just pass it as 0 or nil<br />"
      end

      if data['plans'].present?
        message = "<br />#{message} <code>plans</code> block found<br />"
        if data['plans']['plan_paying_users'].present?
          message = "#{message} <code>plans['plan_paying_users']</code> block found<br />"
        elsif message = "#{message} <code>plans['plan_paying_users']</code> block found<br />"
        end
        if data['plans']['plan_trial_users'].present?
          message = "#{message} <code>plans['plan_trial_users']</code> block found<br />"
        elsif message = "#{message} <code>plans['plan_trial_users']</code> block found<br />"
        end
        if data['plans']['plan_total_users'].present?
          message = "#{message} <code>plans['plan_total_users']</code> block found<br />"
        elsif message = "#{message} <code>plans['plan_total_users']</code> block found<br />"
        end
        if data['plans']['plan_price'].present?
          message = "#{message} <code>plans['plan_price']</code> block found<br />"
        elsif message = "#{message} <code>plans['plan_price']</code> block found<br />"
        end
      else
        message = "<br />#{message} We could not find the plan block <code>plans</code>, kindly check that the data is correctly set up<br />"
      end

      message
    end

    def get_data(endpoint)
      Faraday.get(endpoint)
    end
  end
end

# frozen_string_literal: true

class RunningDatum < ApplicationRecord
  belongs_to :app

  class << self
    def test_endpoint(app_id)
      endpoint = App.find(app_id).running_data_endpoint

      running_data = get_data(endpoint)
      
      response = { status: true, data: [] }

      case running_data.status
      when 200
        data = JSON.parse(running_data.body)
        check_dataset(data, response)
      when 404
        response[:data] << 'The link provided points to nowhere. Kindly double check to confirm that it is the correct link'
        response[:status] = false
        response
      when 500
        response[:data] << 'Something\'s wrong with the data returned. Kindly check that there are no internal errors'
        response[:status] = false
        response
      when 302
        response[:data] << 'Something\'s wrong. Kindly check that the link returns a JSON dataset'
        response[:status] = false
        response
      else
        response[:data] << response[running_data.status]
        response[:status] = false
        
      end
    end

    def check_dataset(data, response)
      message = response[:data]

      if data['metrics'].present?
        message << "<span class='material-icons small-icons me-2 text-success'>check</span> <span><code>metrics</code> block found</span>"
        if data['metrics']['gross'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>metrics[:gross]</code> </span>"
        else
          message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>metrics[:gross]</code>, if you don't have or need this just pass it as 0 or nil</span>"
        end

        if data['metrics']['trial'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>metrics[:trial]</code> </span>"
        else
          message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>metrics[:trial]</code>, if you don't have or need this just pass it as 0 or nil</span>"
        end

        if data['metrics']['paying_users'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>metrics[:paying_users]</code> </span>"
        else
          message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>metrics[:paying_users]</code>, if you don't have or need this just pass it as 0 or nil</span>"
        end

        if data['metrics']['trial_users'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>metrics[:trial_users]</code> </span>"
        else
          message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>metrics[:trial_users]</code>, if you don't have or need this just pass it as 0 or nil</span>"
        end
      else
        message << "<span class='material-icons small-icons me-2 text-danger'>cancel</span> <span>We could not find the <code>metrics</code> block, kindly check that the data is correctly set up</span>"
      end

      if data['plans'].present?
        message << "<span class='material-icons small-icons me-2 text-success'>check</span> <span><code>plans</code> block found</span>"
        if data['plans'].first['plan_name'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>plans['plan_name']</code> block found</span>"
        elsif message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>plans[:plan_name]</code> Kindly check to ensure the data is set right</span>"
        end
        if data['plans'].first['plan_paying_users'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>plans['plan_paying_users']</code> block found</span>"
        elsif message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>plans[:plan_paying_users]</code> Kindly check to ensure the data is set right</span>"
        end
        if data['plans'].first['plan_trial_users'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>plans['plan_trial_users']</code> block found</span>"
        elsif message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>plans[:plan_trial_users]</code> Kindly check to ensure the data is set right</span>"
        end
        if data['plans'].first['plan_total_users'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>plans['plan_total_users']</code> block found</span>"
        elsif message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>plans[:plan_total_users]</code> Kindly check to ensure the data is set right</span>"
        end
        if data['plans'].first['plan_price'].present?
          message << "<span class='material-icons small-icons me-2 text-success ms-3'>check</span> <span><code>plans['plan_price']</code> block found</span>"
        elsif message << "<span class='material-icons small-icons me-2 text-danger ms-3'>cancel</span> <span>We could not find <code>plans[:plan_price]</code> Kindly check to ensure the data is set right</span>"
        end
      else
        message << "<span class='material-icons small-icons me-2 text-danger'>cancel</span> <span>We could not find the plan block <code>plans</code>, kindly check that the data is correctly set up</span>"
      end

      if data['metrics'].blank? || data['metrics']['gross'].blank? || data['metrics']['trial'].blank? || data['metrics']['paying_users'].blank? || data['metrics']['trial_users'].blank? || data['plans'].blank? || data['plans'].first['plan_name'].blank? || data['plans'].first['plan_paying_users'].blank? || data['plans'].first['plan_trial_users'].blank? || data['plans'].first['plan_total_users'].blank? || data['plans'].first['plan_price'].blank?
        response[:status] = false
      end

      response
    end

    def get_data(endpoint)
      Faraday.get(endpoint)
    end
  end
end

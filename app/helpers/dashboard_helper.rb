# frozen_string_literal: true

module DashboardHelper
  def my_apps(user_id)
    App.where(user_id: user_id)
  end

  def my_app_count(user_id)
    App.where(user_id: user_id).count
  end
end

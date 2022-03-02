# frozen_string_literal: true

class GarageController < ApplicationController
  before_action :authenticate_user!
end

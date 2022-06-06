# frozen_string_literal: true

class PlansController < InheritedResources::Base
  private

  def plan_params
    params.require(:plan).permit(:name, :has_exports, :has_breakdown, :price, :has_csv_import)
  end
end

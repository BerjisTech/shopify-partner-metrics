class BillingsController < InheritedResources::Base

  private

    def billing_params
      params.require(:billing).permit(:app_id, :user_id, :business_id, :amount, :plan_id)
    end

end

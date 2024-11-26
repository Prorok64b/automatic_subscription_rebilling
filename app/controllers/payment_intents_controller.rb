class PaymentIntentsController < ApplicationController
  def create
    subscription = Subscription.find(filtered_params[:subscription_id])

    result = BillingDispatcher.call(subscription: subscription)

    render json: { status: result }
  end

  private

  def filtered_params
    params.permit(:subscription_id)
  end
end

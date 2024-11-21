class PaymentIntentsController < ApplicationController
  def create
  end

  private

  def params
    params.permit(:amount, :subscription_id)
  end
end

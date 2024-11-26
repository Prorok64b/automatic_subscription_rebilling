class SubscriptionsPaymentOnAllowNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :subscriptions, :payment_on, true
  end
end

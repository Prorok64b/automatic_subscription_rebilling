class RenameSubscriptionNextPaymentOnToPaymentOn < ActiveRecord::Migration[7.2]
  def change
    rename_column :subscriptions, :next_payment_on, :payment_on
  end
end

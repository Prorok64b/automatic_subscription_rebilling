class AddCashAmountPaidToSubscription < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :cash_amount_paid, :decimal, null: false, default: 0
  end
end

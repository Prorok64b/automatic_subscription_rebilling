class CleanUnusedColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :payment_orders, :percentage_paid
    remove_column :subscriptions, :percentage_paid
  end
end

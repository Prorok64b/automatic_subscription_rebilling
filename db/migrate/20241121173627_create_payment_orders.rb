class CreatePaymentOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_orders do |t|
      t.string :status, null: false
      t.decimal :cash_amount, null: false
      t.integer :percentage_paid, null: false
      t.references :subscription

      t.timestamps
    end
  end
end

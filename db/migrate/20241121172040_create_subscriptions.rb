class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.integer :percentage_paid, null: false
      t.date :next_payment_on, null: false

      t.references :user

      t.timestamps
    end
  end
end

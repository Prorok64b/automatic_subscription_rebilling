class AddPriceFieldToSubscription < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :price, :decimal, null: false
  end
end

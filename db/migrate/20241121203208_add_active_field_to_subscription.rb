class AddActiveFieldToSubscription < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :active, :boolean, null: false, default: false

    add_index :subscriptions, :active
  end
end

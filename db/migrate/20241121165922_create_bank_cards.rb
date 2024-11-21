class CreateBankCards < ActiveRecord::Migration[7.2]
  def change
    create_table :bank_cards do |t|
      t.string :number, null: false
      t.string :expiry_month, null: false
      t.string :expiry_year, null: false
      t.string :cvv, null: false

      t.boolean :primary, null: false, default: false

      t.references :user

      t.timestamps
    end
  end
end

class Subscription < ApplicationRecord
  belongs_to :user

  has_many :payment_orders

  def fully_paid?
    cash_amount_paid == price
  end

  def partialy_paid?
    cash_amount_paid > 0 && cash_amount_paid < price
  end

  def unpaid?
    cash_amount_paid.zero?
  end

  def expired?
    return false unless payment_on

    payment_on < Date.today
  end
end

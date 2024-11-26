class Subscription < ApplicationRecord
  belongs_to :user

  validates :percentage_paid, presence: true, inclusion: { in: [0, 25, 50, 75, 100] }
  validates :payment_on, presence: true

  def fully_paid?
    cash_amount_paid == price
  end

  def partialy_paid?
    cash_amount_paid > 0 && cash_amount_paid < price
  end

  def unpaid?
    cash_amount_paid.zero?
  end
end

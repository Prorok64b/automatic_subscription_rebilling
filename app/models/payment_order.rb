class PaymentOrder < ApplicationRecord
  belongs_to :subscription

  enum status: { pending: 'pending', success: 'success', fail: 'fail' }

  validates :cash_amount, presence: true
  validates :percentage_paid, presence: true, inclusion: { in: [0, 25, 50, 75, 100] }
end

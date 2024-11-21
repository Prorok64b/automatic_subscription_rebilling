class Subscription < ApplicationRecord
  belongs_to :user

  validates :percentage_paid, presence: true, inclusion: { in: [0, 25, 50, 75, 100] }
  validates :next_payment_on, presence: true
end

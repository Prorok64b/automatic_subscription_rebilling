class BankCard < ApplicationRecord
  belongs_to :user

  validates :number, presence: true
  validates :expiry_month, presence: true
  validates :expiry_year, presence: true
  validates :cvv, presence: true
  validates :primary, presence: true, uniqueness: { scope: :user_id }
end
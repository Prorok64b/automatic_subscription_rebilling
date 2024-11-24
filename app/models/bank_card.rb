class BankCard < ApplicationRecord
  belongs_to :user

  scope :primary, -> { where(primary: true) }

  validates :number, presence: true
  validates :expiry_month, presence: true
  validates :expiry_year, presence: true
  validates :cvv, presence: true

  validate :only_one_primary_per_user

  private

  def only_one_primary_per_user
    return unless primary?
    return if self.class.primary.where(user_id: user.id).count.zero?

    errors.add(:base, 'Only one primary card per user allowed')
  end
end

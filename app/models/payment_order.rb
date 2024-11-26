class PaymentOrder < ApplicationRecord
  class Statuses
    CREATED            = 'created'.freeze
    PENDING            = 'pending'.freeze
    SUCCESS            = 'success'.freeze
    INSUFFICIENT_FUNDS = 'insufficient_funds'.freeze
    PARTIAL_SUCCESS    = 'partial_success'.freeze
    ERROR              = 'error'.freeze
  end

  belongs_to :subscription

  enum status: {
    created:           Statuses::CREATED,
    pending:           Statuses::PENDING,
    success:           Statuses::SUCCESS,
    insufficient_funds: Statuses::INSUFFICIENT_FUNDS,
    partial_success:   Statuses::PARTIAL_SUCCESS,
    error:             Statuses::ERROR
  }

  validates :cash_amount, presence: true
end

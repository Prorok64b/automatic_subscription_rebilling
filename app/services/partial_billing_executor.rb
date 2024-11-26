class PartialBillingExecutor
  def self.call(...)
    new(...).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    Subscriptions::CashPayer.call(subscription, cash_amount_to_pay)
  end

  private

  attr_reader :subscription

  def cash_amount_to_pay
    Subscriptions::RemainingDiffCalculator.call(subscription)
  end
end

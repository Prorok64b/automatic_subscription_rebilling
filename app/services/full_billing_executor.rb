class FullBillingExecutor
  def self.call(...)
    new(...).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    # let's try to charge 100%
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      subscription.price
    )

    return payment_order unless payment_order.insufficient_funds?

    # to charge 75%
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(75)
    )

    return payment_order unless payment_order.insufficient_funds?

    # to charge 50%
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(50)
    )

    return payment_order unless payment_order.insufficient_funds?

    # to charge 25%
    Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(25)
    )
  end

  private

  attr_reader :subscription

  def next_try_cash_amount(percentage)
    Subscriptions::PricePercentCalculator.call(subscription, percentage)
  end
end

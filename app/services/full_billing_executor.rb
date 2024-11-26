class FullBillingExecutor
  def self.call(...)
    new(...).call
  end

  def initialize(subscription)
    @subscription = subscription
  end

  def call
    # let's try to charge 100%
    print_log('try to charge 100%')
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      subscription.price
    )

    print_log('charged 100%') if payment_order.success?

    return payment_order unless payment_order.insufficient_funds?

    # to charge 75%
    print_log('try to charge 75%')
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(75)
    )

    print_log('charged 75%') if payment_order.success?

    return payment_order unless payment_order.insufficient_funds?

    # to charge 50%
    print_log('try to charge 50%')
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(50)
    )

    print_log('charged 50%') if payment_order.success?

    return payment_order unless payment_order.insufficient_funds?

    # to charge 25%
    print_log('try to charge 25%')
    payment_order = Subscriptions::CashPayer.call(
      subscription,
      next_try_cash_amount(25)
    )

    print_log('charged 25%') if payment_order.success?

    payment_order
  end

  private

  attr_reader :subscription

  def next_try_cash_amount(percentage)
    Subscriptions::PricePercentCalculator.call(subscription, percentage)
  end

  def print_log(message)
    Rails.logger.info(
      "#{self.class.to_s}: subscription #{subscription.id} - #{message}"
    )
  end
end

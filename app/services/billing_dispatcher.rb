class BillingDispatcher
  def self.call(...)
    new(...).call
  end

  def initialize(subscription:, cash_amount: nil)
    @subscription = subscription
    @cash_amount = cash_amount
  end

  def call
    print_log("[START PROCESSING]")

    # raise error if subscription.fully_paid?

    return perform_full_payment if subscription.unpaid?

    perform_partial_payment
  end

  private

  attr_reader :subscription, :percentage_paid, :cash_amount

  def perform_full_payment
    payment_order = FullBillingExecutor.call(subscription)

    return handle_success         if payment_order.success?
    return handle_partial_success if payment_order.partial_success?
    return handle_error           if payment_order.error?

    handle_insufficient_funds      if payment_order.insufficient_funds?
  end

  def perform_partial_payment
    payment_order = PartialBillingExecutor.call(subscription)

    # if we pay by parts, payment order for every part will be partial
    return handle_success    if payment_order.partial_success?
    return handle_error      if payment_order.error?

    handle_insufficient_funds if payment_order.insufficient_funds?
  end

  def handle_partial_success
    schedule_in_a_week_retry

    :insufficient_funds
  end

  def handle_success
    Subscriptions::Activator.call(subscription)

    schedule_subscription_renewal

    print_log("[SUCCESS]")

    :success
  end

  def handle_insufficient_funds
    print_log("[INSUFFICIENT FUNDS]")

    :insufficient_funds
  end

  def handle_error
    print_log("[ERROR]")

    :error
  end

  def schedule_in_a_week_retry
    remaining_diff = Subscriptions::RemainingDiffCalculator.call(subscription)

    print_log("RETRY in a WEEK with #{remaining_diff}$")

    SubscriptionPaymentWorker.perform_at(1.week, subscription.id)
  end

  def schedule_subscription_renewal
    SubscriptionPaymentWorker.perform_in(
      subscription.payment_on.to_datetime,
      subscription.id
    )
  end

  def print_log(message)
    Rails.logger.info(
      "#{self.class.to_s}: subscription #{subscription.id} - #{message}"
    )
  end
end

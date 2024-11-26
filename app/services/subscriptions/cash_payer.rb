module Subscriptions
  class CashPayer
    def self.call(...)
      new(...).call
    end

    def initialize(subscription, cash_amount)
      @subscription = subscription
      @cash_amount = cash_amount
    end

    def call
      result = PaymentOrders::Executor.call(payment_order)

      case result.code
      when :success
        handle_success
      when :insufficient_funds
        handle_insufficient_funds
      when :error
        handle_error
      end

      payment_order
    end

    private

    attr_reader :subscription, :cash_amount

    def handle_success
      ApplicationRecord.transaction do
        subscription.update!(cash_amount_paid: cash_amount)
        payment_order.update!(status: new_success_status)
      end
    end

    def handle_insufficient_funds
      payment_order.update!(status: PaymentOrder::Statuses::INSUFFICIENT_FUNDS)
    end

    def handle_error
      payment_order.update!(status: PaymentOrder::Statuses::ERROR)
    end

    def new_success_status
      return PaymentOrder::Statuses::SUCCESS if cash_amount == subscription.price
      return PaymentOrder::Statuses::PARTIAL_SUCCESS if cash_amount < subscription.price
    end

    def payment_order
      @payment_order ||= PaymentOrders::Creator.call(subscription, cash_amount_to_pay)
    end

    def cash_amount_to_pay
      # we don't want to pay more then subscription costs
      return subscription.price if cash_amount >= subscription.price

      cash_amount
    end
  end
end

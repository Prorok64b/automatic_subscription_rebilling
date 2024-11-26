module Subscriptions
  class RemainingDiffCalculator
    def self.call(...)
      new(...).call
    end

    def initialize(subscription)
      @subscription = subscription
    end

    def call
      return 0 if subscription.fully_paid?
      return subscription.price if subscription.unpaid?

      subscription.price - subscription.cash_amount_paid
    end

    private

    attr_reader :subscription
  end
end

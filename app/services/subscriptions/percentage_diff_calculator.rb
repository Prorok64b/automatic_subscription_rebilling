module Subscriptions
  class PercentageDiffCalculator
    # used to calculate the difference between:
    # percentage already paid and reamining percentage to pay

    def self.call(...)
      new(...).call
    end

    def initialize(subscription)
      @subscription = subscription
    end

    def call
      return 0 if subscription.fully_paid?
      # TODO: ensure that result is on the list
      100 - subscription.percentage_paid
    end

    private

    attr_reader :subscription
  end
end

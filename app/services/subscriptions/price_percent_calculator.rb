module Subscriptions
  class PricePercentCalculator
    def self.call(...)
      new(...).call
    end

    def initialize(subscription, percentage)
      @subscription = subscription
      @percentage = percentage
    end

    def call
      subscription.price * percentage / 100
    end

    private

    attr_reader :subscription, :percentage
  end
end

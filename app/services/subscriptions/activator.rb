module Subscriptions
  class Activator
    def self.call(...)
      new(...).call
    end

    def initialize(subscription)
      @subscription = subscription
      @current_payment_on = subscription.payment_on
    end

    def call
      subscription.update!(
        active: true,
        payment_on: new_payment_on
      )
    end

    private

    attr_reader :subscription, :current_payment_on

    def new_payment_on
      current_payment_on + 1.month
    end
  end
end

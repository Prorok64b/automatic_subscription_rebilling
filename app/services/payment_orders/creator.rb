module PaymentOrders
  class Creator
    def self.call(...)
      new(...).call
    end

    def initialize(subscription, cash_amount)
      @subscription = subscription
      @cash_amount = cash_amount
    end

    def call
      PaymentOrder.create!(
        subscription: subscription,
        status: PaymentOrder::Statuses::CREATED,
        cash_amount: cash_amount_to_pay
      )
    end

    private

    attr_reader :subscription, :cash_amount

    def cash_amount_to_pay
      return subscription.price if subscription.price <= cash_amount

      cash_amount
    end
  end
end

module PaymentOrders
  class Creator
    def self.call(...)
      new(...).call
    end

    def initialize(subscription, percentage)
      @subscription = subscription
      @percentage = percentage
    end

    def call
      PaymentOrder.create!(
        subscription: subscription,
        status: PaymentOrder::Statuses::CREATED,
        percentage_paid: percentage,
        cash_amount: BigDecimal('0') # TODO: to remove
      )
    end

    private

    attr_reader :subscription, :percentage
  end
end

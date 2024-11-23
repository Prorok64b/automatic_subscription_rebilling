module PaymentOrders
  class NextChargePercentage
    def self.call(...)
      new(...).call
    end

    def initialize(payment_order)
      @payment_order = payment_order
    end

    def call
      case payment_order.percentage_paid
      when 100
        75
      when 75
        50
      when 50
        25
      when 25
        nil
      end
    end

    private

    attr_reader :payment_order
  end
end

module PaymentOrders
  class NextChargePercentage
    class UnknownPercentageValue < StandardError; end

    def self.call(...)
      new(...).call
    end

    def initialize(payment_order)
      @payment_order = payment_order
    end

    def call
      case percentage_paid
      when 100
        75
      when 75
        50
      when 50
        25
      when 25
        nil
      else
        raise UnknownPercentageValue, percentage_paid
      end
    end

    private

    attr_reader :payment_order

    def percentage_paid
      payment_order.percentage_paid
    end
  end
end

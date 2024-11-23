module PaymentOrders
  class Executor
    class Result
      def initialize(code:)
        @code = code
      end

      attr_reader :code
    end

    def self.call(...)
      new(...).call
    end

    def initialize(payment_order)
      @payment_order = payment_order
    end

    def call
      response = Bank::CardCharger.call(bank_card, cash_amount)

      case response.code
      when :success
        handle_success
      when :insufficient_funds
        Result.new(code: :insufficient_funds)
      when :error
        Result.new(code: :error)
      end
    end

    private

    attr_reader :payment_order

    def handle_success
      Result.new(code: :success)
    end

    def cash_amount
      percentile = BigDecimal(payment_order.percentage_paid) / 100

      subscription.price * percentile
    end

    def subscription
      @subscription ||= payment_order.subscription
    end

    def bank_card
      @bank_card ||= subscription.user.primary_bank_card
    end
  end
end

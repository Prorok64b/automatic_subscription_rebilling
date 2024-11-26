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
      # TODO: disable processing orders with status 'success'
      print_log('[PROCESSING]')

      response = Bank::CardCharger.call(bank_card, payment_order.cash_amount)

      print_log(response.to_s)

      case response.code
      when :success
        handle_success
      when :insufficient_funds
        handle_insufficient_funds
      when :error
        handle_error
      end
    end

    private

    attr_reader :payment_order

    def handle_success
      print_log('[SUCCESS]')

      Result.new(code: :success)
    end

    def handle_insufficient_funds
      print_log('[INSUFICCIENT FUNDS]')

      Result.new(code: :insufficient_funds)
    end

    def handle_error
      print_log('[ERROR]')

      Result.new(code: :error)
    end

    def subscription
      @subscription ||= payment_order.subscription
    end

    def bank_card
      @bank_card ||= subscription.user.primary_bank_card
    end

    def print_log(message)
      Rails.logger.info("#{self.class.to_s}: payment order #{payment_order.id}: #{message}")
    end
  end
end

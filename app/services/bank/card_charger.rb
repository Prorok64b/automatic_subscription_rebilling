module Bank
  class CardCharger
    # A mock class that gonna emulate card payment.
    # Testing purpuses only!

    class Response
      def initialize(code:, msg:)
        @code = code
        @msg = msg
      end

      attr_reader :code, :msg

      def to_s
        "Bank response: code: #{code}, message: #{msg}"
      end
    end

    def self.call(...)
      new(...).call
    end

    def initialize(bank_card, cash_amount)
      @bank_card = bank_card
      @cash_amount = cash_amount
    end

    def call
      return error if ENV['BEHAVIOR'] == 'error'
      return success if cash_amount <= ENV['CASH_AMOUNT_ON_BANK_ACCOUNT'].to_i
      return insufficient_funds if cash_amount > ENV['CASH_AMOUNT_ON_BANK_ACCOUNT'].to_i
    end

    private

    attr_reader :bank_card, :cash_amount

    def success
      Bank::CardCharger::Response.new(
        code: :success,
        msg: 'Transaction has been completed!'
      )
    end

    def insufficient_funds
      Bank::CardCharger::Response.new(
        code: :insufficient_funds,
        msg: 'Insufficient funds on the bank account'
      )
    end

    def error
      Bank::CardCharger::Response.new(
        code: :error,
        msg: 'Invalid card number'
      )
    end
  end
end

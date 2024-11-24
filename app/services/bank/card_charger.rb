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
    end

    def self.call(...)
      new(...).call
    end

    def initialize(bank_card, cash_amount)
      @bank_card = bank_card
      @cash_amount = cash_amount
    end

    def call
      Bank::CardCharger::Response.new(
        code: :success,
        msg: 'Transaction has been completed!'
      )
    end

    private

    attr_reader :bank_card, :cash_amount
  end
end

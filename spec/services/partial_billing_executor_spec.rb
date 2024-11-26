require 'rails_helper'

describe PartialBillingExecutor do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:user) { build(:user, bank_cards: [bank_card]) }
    let(:bank_card) { build(:bank_card, :primary) }
    let!(:subscription) do
      create(:subscription, price: 100, cash_amount_paid: BigDecimal('50'), user: user)
    end

    let(:success_bank_response) do
      Bank::CardCharger::Response.new(
        code: :success,
        msg: 'Transaction has been completed!'
      )
    end

    let(:insufficient_funds_bank_response) do
      Bank::CardCharger::Response.new(
        code: :insufficient_funds,
        msg: 'Insufficient funds on the bank account'
      )
    end

    let(:error_bank_response) do
      Bank::CardCharger::Response.new(
        code: :error,
        msg: 'Invalid card number'
      )
    end

    context 'when there is enough funds' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('50'))
          .and_return(success_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::PARTIAL_SUCCESS,
          cash_amount: BigDecimal('50')
        )
      end
    end

    context 'when there is no enough funds' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('50'))
          .and_return(insufficient_funds_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::INSUFFICIENT_FUNDS,
          cash_amount: BigDecimal('50')
        )
      end
    end

    context 'when bank responses with error' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('50'))
          .and_return(error_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::ERROR,
          cash_amount: BigDecimal('50')
        )
      end
    end
  end
end

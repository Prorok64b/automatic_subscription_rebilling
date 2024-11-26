require 'rails_helper'

describe FullBillingExecutor do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:user) { build(:user, bank_cards: [bank_card]) }
    let(:bank_card) { build(:bank_card, :primary) }
    let!(:subscription) do
      create(:subscription, price: 100, user: user, cash_amount_paid: 0)
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

    before do
      allow(Bank::CardCharger).to receive(:call)
        .and_return(insufficient_funds_bank_response)
    end

    context 'when there is enough funds to pay 100%' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('100'))
          .and_return(success_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::SUCCESS,
          cash_amount: BigDecimal('100')
        )
      end
    end

    context 'when there is enough funds to pay only 75%' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('75'))
          .and_return(success_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::PARTIAL_SUCCESS,
          cash_amount: BigDecimal('75')
        )
      end
    end

    context 'when there is enough funds to pay only 50%' do
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

    context 'when there is enough funds to pay only 25%' do
      before do
        allow(Bank::CardCharger).to receive(:call)
          .with(bank_card, BigDecimal('25'))
          .and_return(success_bank_response)
      end

      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::PARTIAL_SUCCESS,
          cash_amount: BigDecimal('25')
        )
      end
    end

    context 'when no funds to pay even 25%' do
      it 'returns payment_order with proper attributes' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::INSUFFICIENT_FUNDS,
          cash_amount: BigDecimal('25')
        )
      end
    end
  end
end

require 'rails_helper'

describe Subscriptions::CashPayer do
  describe '.call' do
    subject { described_class.call(subscription, cash_amount) }

    let!(:subscription) do
      create(
        :subscription,
        price: BigDecimal('99.99'),
        cash_amount_paid: 0
      )
    end

    let(:bank_response) do
      Bank::CardCharger::Response.new(
        code: :success,
        msg: 'Transaction has been completed!'
      )
    end

    before do
      allow(Bank::CardCharger).to receive(:call)
        .and_return(bank_response)
    end

    context 'when given cash_amount 99.99' do
      let(:cash_amount) { BigDecimal('99.99') }

      it 'creates new payment order' do
        expect { subject }.to change { PaymentOrder.count }.by(1)
      end

      it 'returns payment_order with a proper status' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::SUCCESS
        )
      end

      it 'updates subscription\'s cash_amount_paid field' do
        expect { subject }.to change { subscription.cash_amount_paid }
          .from(0).to(cash_amount)
      end
    end

    context 'when given cash_amount 50.99' do
      let(:cash_amount) { BigDecimal('50.99') }

      it 'creates new payment order' do
        expect { subject }.to change { PaymentOrder.count }.by(1)
      end

      it 'returns payment_order with a proper status' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::PARTIAL_SUCCESS
        )
      end

      it 'updates subscription\'s cash_amount_paid field' do
        expect { subject }.to change { subscription.cash_amount_paid }
          .from(0).to(cash_amount)
      end
    end

    context 'when bank responses with insufficient funds' do
      let(:cash_amount) { BigDecimal('99.99') }

      let(:bank_response) do
        Bank::CardCharger::Response.new(
          code: :insufficient_funds,
          msg: 'Insufficient funds on the bank account'
        )
      end

      it 'returns payment_order with a proper status' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::INSUFFICIENT_FUNDS
        )
      end
    end

    context 'when bank responses with error' do
      let(:cash_amount) { BigDecimal('99.99') }

      let(:bank_response) do
        Bank::CardCharger::Response.new(
          code: :error,
          msg: 'Invalid card number'
        )
      end

      it 'returns payment_order with a proper status' do
        expect(subject).to have_attributes(
          status: PaymentOrder::Statuses::ERROR
        )
      end
    end
  end
end

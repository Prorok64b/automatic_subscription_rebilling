require 'rails_helper'

describe PaymentOrders::Executor do
  describe '.call' do
    subject { described_class.call(payment_order) }

    let(:user) { build(:user, bank_cards: [bank_card]) }
    let(:bank_card) { build(:bank_card, :primary) }
    let(:subscription) { create(:subscription, :inactive, user: user, price: 100) }

    let!(:payment_order) do
      create(
        :payment_order,
        subscription: subscription,
        cash_amount: BigDecimal('100')
      )
    end

    before do
      allow(Bank::CardCharger).to receive(:call)
        .with(bank_card, payment_order.cash_amount)
        .and_return(bank_response)
    end

    shared_examples_for 'returns result instance' do |code|
      it 'returns Result instance' do
        expect(subject).to be_instance_of(described_class::Result)
      end

      it 'returns proper code' do
        expect(subject.code).to eq(code)
      end
    end

    context 'when given a card with enough funds' do
      let(:bank_response) do
        Bank::CardCharger::Response.new(
          code: :success,
          msg: 'Transaction has been completed!'
        )
      end

      include_examples 'returns result instance', :success
    end

    context 'when given a card with insufficient funds' do
      let(:bank_response) do
        Bank::CardCharger::Response.new(
          code: :insufficient_funds,
          msg: 'Insufficient funds on the bank account'
        )
      end

      include_examples 'returns result instance', :insufficient_funds
    end

    context 'when given an invalid card' do
      let(:bank_response) do
        Bank::CardCharger::Response.new(
          code: :error,
          msg: 'Invalid card number'
        )
      end

      include_examples 'returns result instance', :error
    end
  end
end

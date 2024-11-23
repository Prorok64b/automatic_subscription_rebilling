require 'rails_helper'

describe PaymentOrders::NextChargePercentage do
  describe '.call' do
    subject { described_class.call(payment_order) }

    let(:payment_order) { build(:payment_order, percentage_paid: percentage_paid) }

    context 'when given payment_order with 100 percentage' do
      let(:percentage_paid) { 100 }

      it { is_expected.to eq(75) }
    end

    context 'when given payment_order with 75 percentage' do
      let(:percentage_paid) { 75 }

      it { is_expected.to eq(50) }
    end

    context 'when given payment_order with 50 percentage' do
      let(:percentage_paid) { 50 }

      it { is_expected.to eq(25) }
    end

    context 'when given payment_order with 25 percentage' do
      let(:percentage_paid) { 25 }

      it { is_expected.to eq(nil) }
    end

    context 'when given payment_order with 33 percentage' do
      let(:percentage_paid) { 33 }

      it 'raises an error' do
        expect { subject }.to raise_error(described_class::UnknownPercentageValue)
      end
    end
  end
end

require 'rails_helper'

describe Subscriptions::RemainingDiffCalculator do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:subscription) do
      build(:subscription, price: BigDecimal('99.99'), cash_amount_paid: cash_amount_paid)
    end

    context 'when 24 has been paid' do
      let(:cash_amount_paid) { 24 }

      it { is_expected.to eq(BigDecimal('75.99')) }
    end

    context 'when 50 has been paid' do
      let(:cash_amount_paid) { 40 }

      it { is_expected.to eq(BigDecimal('59.99')) }
    end

    context 'when 0 has been paid' do
      let(:cash_amount_paid) { 0 }

      it { is_expected.to eq(BigDecimal('99.99')) }
    end

    context 'when full price has been paid' do
      let(:cash_amount_paid) { BigDecimal('99.99') }

      it { is_expected.to eq(0) }
    end
  end
end

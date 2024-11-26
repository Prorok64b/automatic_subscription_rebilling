require 'rails_helper'

describe Subscriptions::PricePercentCalculator do
  describe '.call' do
    subject { described_class.call(subscription, percentage) }

    let(:subscription) { build(:subscription, price: BigDecimal('99.99')) }

    context 'when given 75 percentage' do
      let(:percentage) { 75 }

      it { is_expected.to eq(BigDecimal('74.9925')) }
    end

    context 'when given 50 percentage' do
      let(:percentage) { 50 }

      it { is_expected.to eq(BigDecimal('49.995')) }
    end

    context 'when given 25 percentage' do
      let(:percentage) { 25 }

      it { is_expected.to eq(BigDecimal('24.9975')) }
    end
  end
end

require 'rails_helper'

describe Subscriptions::PercentageDiffCalculator do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:subscription) { build(:subscription, percentage_paid: percentage_paid) }

    context 'when given subscription paid for 100%' do
      let(:percentage_paid) { 100 }

      it { is_expected.to eq(0) }
    end

    context 'when given subscription paid for 75%' do
      let(:percentage_paid) { 75 }

      it { is_expected.to eq(25) }
    end

    context 'when given subscription paid for 50%' do
      let(:percentage_paid) { 50 }

      it { is_expected.to eq(50) }
    end

    context 'when given subscription paid for 25%' do
      let(:percentage_paid) { 25 }

      it { is_expected.to eq(75) }
    end

    context 'when given subscription paid for 0%' do
      let(:percentage_paid) { 0 }

      it { is_expected.to eq(100) }
    end
  end
end

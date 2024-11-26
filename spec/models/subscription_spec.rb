require 'rails_helper'

describe Subscription, type: :model do
  describe "#fully_paid?" do
    subject { instance.fully_paid? }

    context 'when given fully paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 100, price: 100) }

      it { is_expected.to eq(true) }
    end

    context 'when given partialy paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 50, price: 100) }

      it { is_expected.to eq(false) }
    end

    context 'when given unpaid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 0, price: 100) }

      it { is_expected.to eq(false) }
    end
  end

  describe "#partialy_paid?" do
    subject { instance.partialy_paid? }

    context 'when given fully paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 100, price: 100) }

      it { is_expected.to eq(false) }
    end

    context 'when given partialy paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 50, price: 100) }

      it { is_expected.to eq(true) }
    end

    context 'when given unpaid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 0, price: 100) }

      it { is_expected.to eq(false) }
    end
  end

  describe "#unpaid?" do
    subject { instance.unpaid? }

    context 'when given fully paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 100, price: 100) }

      it { is_expected.to eq(false) }
    end

    context 'when given partialy paid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 50, price: 100) }

      it { is_expected.to eq(false) }
    end

    context 'when given unpaid subscription' do
      let(:instance) { build(:subscription, cash_amount_paid: 0, price: 100) }

      it { is_expected.to eq(true) }
    end
  end
end

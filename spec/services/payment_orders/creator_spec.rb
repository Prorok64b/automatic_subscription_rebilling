require 'rails_helper'

describe PaymentOrders::Creator do
  describe '.call' do
    subject { described_class.call(subscription, percentage) }

    let!(:subscription) { create(:subscription) }
    let(:percentage) { 100 }

    it 'creates new PaymentOrder' do
      expect { subject }.to change { PaymentOrder.count }.by(1)
    end

    it 'returns newly created PaymentOrder' do
      expect(subject).to have_attributes(
        subscription_id: subscription.id,
        status: PaymentOrder::Statuses::CREATED,
        percentage_paid: percentage,
        cash_amount: BigDecimal('0')
      )
    end
  end
end

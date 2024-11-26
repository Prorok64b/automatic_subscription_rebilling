require 'rails_helper'

describe PaymentOrders::Creator do
  describe '.call' do
    subject { described_class.call(subscription, amount) }

    let!(:subscription) { create(:subscription, price: BigDecimal('80')) }
    let(:amount) { BigDecimal('99.99') }

    it 'creates new PaymentOrder' do
      expect { subject }.to change { PaymentOrder.count }.by(1)
    end

    it 'returns newly created PaymentOrder' do
      expect(subject).to have_attributes(
        subscription_id: subscription.id,
        status: PaymentOrder::Statuses::CREATED,
        cash_amount: BigDecimal('80')
      )
    end
  end
end

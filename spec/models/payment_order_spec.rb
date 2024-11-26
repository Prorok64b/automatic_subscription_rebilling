require 'rails_helper'

describe PaymentOrder, type: :model do
  let(:subscription) { build(:subscription) }
  let(:instance) { build(:payment_order, subscription: subscription) }

  it 'saves an instance' do
    expect(instance.save).to eq(true)
  end
end

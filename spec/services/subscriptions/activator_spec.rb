require 'rails_helper'

describe Subscriptions::Activator do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:current_payment_on) { Date.new(2024, 11, 22) }
    let(:new_payment_on) { Date.new(2024, 12, 22) }
    let!(:subscription) { create(:subscription, :inactive, payment_on: current_payment_on) }

    it 'updates proper fields' do
      expect { subject; subscription.reload }
        .to change { subscription.active }.from(false).to(true)
        .and change { subscription.payment_on }.from(current_payment_on).to(new_payment_on)
    end
  end
end

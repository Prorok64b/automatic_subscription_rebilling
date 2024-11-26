require 'rails_helper'

describe Subscriptions::Activator do
  describe '.call' do
    subject { described_class.call(subscription) }

    let(:new_payment_on) { Date.today + 1.month }
    let!(:subscription) { create(:subscription, :inactive, payment_on: nil) }

    it 'updates proper fields' do
      expect { subject; subscription.reload }
        .to change { subscription.active }.from(false).to(true)
        .and change { subscription.payment_on }.from(nil).to(new_payment_on)
    end
  end
end

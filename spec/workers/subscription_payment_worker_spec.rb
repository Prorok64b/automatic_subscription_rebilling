require 'rails_helper'

describe SubscriptionPaymentWorker do
  describe '.perform' do
    subject { described_class.new.perform(subscription.id) }

    let!(:subscription) { create(:subscription) }

    before do
      allow(BillingDispatcher).to receive(:call)
    end

    it 'calls BillingDispatcher with proper args' do
      subject

      expect(BillingDispatcher).to have_received(:call)
        .with(subscription: subscription)
    end
  end
end

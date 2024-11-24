require 'rails_helper'

describe SubscriptionPaymentWorker do
  describe '.perform' do
    subject { described_class.new.perform(subscription.id, percentage_paid) }

    let!(:subscription) { create(:subscription) }
    let(:percentage_paid) { 75 }

    before do
      allow(BillingDispatcher).to receive(:call)
    end

    it 'calls BillingDispatcher with proper args' do
      subject

      expect(BillingDispatcher).to have_received(:call)
        .with(subscription: subscription, percentage_paid: percentage_paid)
    end
  end
end

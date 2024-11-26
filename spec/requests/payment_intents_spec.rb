require 'rails_helper'

RSpec.describe PaymentIntentsController, type: :request do
  describe '/create' do
    subject { post '/paymentIntents/create', params: { subscription_id: subscription.id } }

    let(:subscription) { create(:subscription) }
    let(:parsed_body) { JSON.parse(response.body) }
    let(:billing_dispatcher_result) { :success }

    before do
      allow(BillingDispatcher).to receive(:call)
        .with(subscription: subscription)
        .and_return(billing_dispatcher_result)
    end

    it 'responses with proper a message' do
      subject

      expect(parsed_body['status']).to eq('success')
    end

    context 'when dispatcher returns :insufficient_funds' do
      let(:billing_dispatcher_result) { :insufficient_funds }

      it 'responses with proper a message' do
        subject

        expect(parsed_body['status']).to eq('insufficient_funds')
      end
    end

    context 'when dispatcher returns :insufficient_funds' do
      let(:billing_dispatcher_result) { :error }

      it 'responses with proper a message' do
        subject

        expect(parsed_body['status']).to eq('error')
      end
    end
  end
end

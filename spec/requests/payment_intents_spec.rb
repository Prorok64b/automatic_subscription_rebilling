require 'rails_helper'

RSpec.describe PaymentIntentsController, type: :request do
  describe '/create' do
    subject { post '/paymentIntents/create', params }

    let(:params) { {} }

    it { subject }
  end
end

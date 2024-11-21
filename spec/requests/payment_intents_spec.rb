require 'rails_helper'

RSpec.describe PaymentIntentsController, type: :request do
  describe '/create' do
    subject { post '/paymentIntents/create' }

    it { subject }
  end
end

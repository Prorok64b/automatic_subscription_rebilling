class SubscriptionPaymentWorker
  include Sidekiq::Job

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)

    BillingDispatcher.call(subscription: subscription)
  end
end

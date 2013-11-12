module StripeWebhookEvents
  extend ActiveSupport::Concern

  ## https://stripe.com/docs/api#event_types

  WEBHOOK_EVENTS = [
    "account.updated",
    "account.application.deauthorized",
    "balance.available",
    "charge.succeeded",
    "charge.failed",
    "charge.refunded",
    "charge.captured",
    "charge.dispute.created",
    "charge.dispute.updated",
    "charge.dispute.closed",
    "customer.created",
    "customer.updated",
    "customer.deleted",
    "customer.card.created",
    "customer.card.updated",
    "customer.card.deleted",
    "customer.subscription.created",
    "customer.subscription.updated",
    "customer.subscription.deleted",
    "customer.subscription.trial_will_end",
    "customer.discount.created",
    "customer.discount.updated",
    "customer.discount.deleted",
    "invoice.created",
    "invoice.updated",
    "invoice.payment_succeeded",
    "invoice.payment_failed",
    "invoiceitem.created",
    "invoiceitem.updated",
    "invoiceitem.deleted",
    "plan.created",
    "plan.updated",
    "plan.deleted",
    "coupon.created",
    "coupon.deleted",
    "transfer.created",
    "transfer.updated",
    "transfer.paid",
    "transfer.failed",
    "ping"
  ].map{ |event| event.gsub("_", ".") }

  included do
  end

  def method_missing(method, *args, &block)
    if WEBHOOK_EVENTS.include?(method.to_s.gsub("_", "."))
      Rails.logger.info "Undefined StripeWebhook event called: #{method}"
    else
      super
    end
  end

end

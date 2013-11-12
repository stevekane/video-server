class StripeEvent < ActiveRecord::Base
  include StripeWebhookEvents

  belongs_to :subscription

  serialize :data,           Hash
  serialize :stripe_webhook, Hash

  def self.store(params={})
    params.reject!{ |key, value| ["action", "controller"].include?(key) }
    params[:event_id]   = params.delete("id")
    params[:created]    = Time.at(params["created"])
    params[:event_type] = params.delete("type")
    StripeEvent.create(params)
  end

  def process
    method = event_type.to_s.gsub(".", "_")
    send(method)
    update_attribute(:processed, true)
  end

  def data
    Hashie::Mash.new(read_attribute(:data))
  end

  def stripe_webhook
    Hashie::Mash.new(read_attribute(:stripe_webhook))
  end

private

  def invoice_payment_failed
    self.subscription = Subscription.find_by_stripe_id(data.object.lines.data.first.id)
    self.save!
    subscription.suspend!
  end

end

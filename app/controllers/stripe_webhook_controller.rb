class StripeWebhookController < ApplicationController

  respond_to :json

  skip_before_filter :verify_authenticity_token

  def create
    stripe_event = StripeEvent.store(stripe_event_parameters)
    stripe_event.process ## TODO use queueing system for background processing

    head :ok
  end

private

  def stripe_event_parameters
    params.permit!
  end

end

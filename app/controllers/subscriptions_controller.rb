class SubscriptionsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @plans        = Stripe::Plan.all
    @subscription = current_user.subscriptions.build
  end

  def create
    outcome = Subscriptions::Create.run(stripe_token: params[:stripe_token], user: current_user, plan_id: params[:plan_id])
    if outcome.success?
      redirect_to subscription_path(outcome.result)
    else
      flash.now.alert "There was an error creating the subscription."
      render :new
    end
  end

  def show
    @subscription = current_user.subscriptions.find(params[:id])
  end

end

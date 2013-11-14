class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_plans

  def new
    @subscription = current_user.subscriptions.build
  end

  def create
    outcome = Subscriptions::Create.run(stripe_token: params[:stripe_token], user: current_user, plan_id: params[:plan_id])
    if outcome.success?
      redirect_to subscription_path(outcome.result)
    else
      binding.pry
      flash.now[:notice] = "There was an error creating the subscription."
      render :new
    end
  end

  def show
    @subscription = current_user.subscriptions.find(params[:id])
  end

  protected

    def get_plans
      @plans ||= Stripe::Plan.all
    end

end

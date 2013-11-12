class ApiController < ApplicationController
  respond_to :json

  # default implementation for create, update, destroy
  # routes to a Mutation in app/mutations whose class name
  # is a function of the controller and action name.
  include CommandDelegator
  include FilterContext::Controller

  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!

  session :off
end

module CommandDelegator

  def update
    if outcome.success?
      instance_variable_set("@#{ model_name }", outcome.result)
      render "#{ model_name.pluralize }/show"
    else
      render :json => {success: false, errors: outcome.errors.symbolic}, status: 422
    end
  end


  def create
    if outcome.success?
      instance_variable_set("@#{ model_name }", outcome.result)
      render "#{ model_name.pluralize }/show"
    else
      render :json => {success: false, errors: outcome.errors.symbolic}, status: 422
    end
  end

  def destroy
    if outcome.success?
      head :ok
    else
      render :json => {success: false, errors: outcome.errors.symbolic}, status: 422
    end
  end

  protected
    def command_inputs
      {user: current_user, params: params}
    end

    def outcome
      @outcome ||= command_class.run(command_inputs)
    end

    def model_name
      self.class.to_s.gsub('Controller','').singularize.underscore
    end

    def command_class
      action      = action_name.capitalize
      base        = self.class.to_s.gsub('Controller','').singularize

      "#{ action }#{ base }".camelize.constantize
    end

end

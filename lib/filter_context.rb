# The FilterContext class
class FilterContext
  attr_accessor :scope, :user, :params, :results

  def initialize(scope, user, params)
    @scope    = scope
    @params   = params.dup
    @user     = user
  end

  def execute
    build_scope
    @results = self.scope
  end

  def build_scope
  end

  # For ActionController classes
  module Controller
    extend ActiveSupport::Concern

    def index
      results = model_class.query(current_user, params)
      instance_variable_set("@#{ model_name.pluralize }", results)
      respond_with(results)
    end

    def show
      result = model_class.query(current_user, params).find(params[:id])
      instance_variable_set("@#{ model_name }", result)
      respond_with(result)
    end

    protected

      def model_class
        self.class.to_s.gsub('Controller','').singularize.camelize.constantize
      end
  end

  # For ActiveRecord Model classes
  module Delegator
    extend ActiveSupport::Concern

    module ClassMethods
      def filter_context_class
        "#{ self.to_s }FilterContext".camelize.constantize rescue FilterContext
      end

      def query user, params={}
        filter_context_class.new(all,user,params).execute
      end
    end
  end
end

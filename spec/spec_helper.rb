# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

module RspecApiDocumentation
  class RackTestClient < ClientBase
    def parsed_response
      JSON.generate(response_body)
    end
  end
end

RspecApiDocumentation.configure do |config|
  config.format = :json
  config.docs_dir = Rails.root.join("docs")
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = false
  config.order = "random"
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end

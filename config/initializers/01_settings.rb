#Datapimp.send(:extend, Datapimp::ConvenienceMethods)

module Smoothie
  module AppSettings
    config = Hashie::Mash.new(YAML.load(IO.read(::Rails.root.join("config","settings.yml")) ))
    env = config[ Rails.env ]

    GithubClientId =                env.github_client_id
    GithubClientSecret =            env.github_client_secret
    StripeSecretKey =               env.stripe_secret_key
    StripePublicKey =               env.stripe_public_key
  end
end

Jbuilder.key_format :camelize => :lower

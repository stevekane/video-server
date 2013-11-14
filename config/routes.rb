Smoothie::Application.routes.draw do
  root :to => "home#root"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :subscriptions, only: [:new, :create, :show]

  scope :api do
    scope :v1 do
      post "/stripe-webhook", to: "stripe_webhook#create", format: :json
    end
  end

#  root :to => "skypager/serve#page"
end

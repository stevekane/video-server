class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    begin
      @user = User.find_for_github_auth(env['omniauth.auth'])
      sign_in_and_redirect @user, :event => :authentication
    rescue
      flash[:error] = "You are not authorized to use this system.  Peace."
      redirect_to root_path
    end
  end
end

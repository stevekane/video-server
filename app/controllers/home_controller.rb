class HomeController < ApplicationController
  def root
    render "home/marketing", :layout => "theme"
  end
end

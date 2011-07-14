class SessionsController < ApplicationController
  def new
    session[:return_to] = params[:return_to]
    redirect_to "/auth/soundcloud"
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.identify_or_create_from_omniauth(auth)
    session[:user_id] = user.id
    redirect_to session[:return_to] || root_path, :notice => "Logged in"
  end

  def destroy
    session[:user_id] = nil
    redirect_to request.env["HTTP_REFERER"] || root_url, :notice => "Logged out"
  end
end

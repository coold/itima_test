class SessionsController < ApplicationController
  skip_before_filter :log
  def new
  end

  def create
  	user=User.find_by_username(params[:username])
  	if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token]=user.auth_token
      else
        cookies[:auth_token]=user.auth_token
      end
  		redirect_to posts_path, notice: 'Logged in'
  	else
  		redirect_to new_session_path, notice: "Username or password is invalid"
  	end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to posts_path, notice: 'Logged out'
  end

end

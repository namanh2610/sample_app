class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      login_success user
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def login_success user
    log_in user
    if (params[:session][:remember_me] == Settings.value_true)
      remember user
    else
      forget user
    end
    redirect_to user
  end

  def login_fail
    flash.now[:danger] = "Invalid email/password combination"
    render :new
  end
end

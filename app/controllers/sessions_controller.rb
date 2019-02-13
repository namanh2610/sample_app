class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login_success user
      else
        account_not_activated
      end
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
    redirect_back_or user
  end

  def login_fail
    flash.now[:danger] = t ".danger"
    render :new
  end

  def account_not_activated
    message  = t ".message"
    flash[:warning] = message
    redirect_to root_url
  end
end

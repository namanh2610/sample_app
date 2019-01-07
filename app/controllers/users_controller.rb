class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit destroy update)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.active.page(params[:page]).per Settings.number_user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info"
      redirect_to root_url
    else
      flash[:danger] = t ".danger"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".Profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".User_deleted"
    else
      flash[:danger] = t ".cant_User_delete"
    end
    redirect_to users_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".Please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user.current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t ".danger"
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end
end

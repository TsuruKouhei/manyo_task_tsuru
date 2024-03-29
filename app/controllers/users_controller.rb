class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :redirect_logged_in_user, only: [:new]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: t('flush_messege.models.user.update')
      flash[:notice] = "アカウントを更新しました"
    else
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to tasks_path, notice: t('flush_messege.models.user.update')
      flash[:notice] = "アカウントを登録しました"
    else
      render :new
    end
  end

  def show
  end

  def destroy
    if @user.destroy
      redirect_to new_session_path, notice: t('flash.users.create_destroy')
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to current_user unless current_user?(@user)
  end

  def redirect_logged_in_user
    if logged_in?
      redirect_to tasks_path, alert: 'ログアウトしてください'
    end
  end
end

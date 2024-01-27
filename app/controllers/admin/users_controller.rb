class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_admin
  before_action :redirect_logged_in_user, only: [:new]

  def index
    @users = User.includes(:tasks).all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url, notice: 'ユーザを登録しました'
    else
      render :new
    end
  end

  def update
    
    if @user.update(user_params)
      redirect_to admin_users_url, notice: 'ユーザを更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_url, notice: 'ユーザを削除しました'
    else
      redirect_to admin_users_url, alert: @user.errors.full_messages.to_sentence
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def redirect_logged_in_user
      unless current_user&.admin?
        redirect_to tasks_path, alert: 'ログアウトしてください'
      end
    end

    def check_admin
      unless current_user&.admin?
        redirect_to tasks_path, alert: '管理者以外アクセスできません'
      end
    end

end

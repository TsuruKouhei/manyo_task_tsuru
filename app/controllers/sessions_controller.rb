class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :redirect_logged_in_user, only: [:new]
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path
      flash[:notice] = "ログインしました"
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end

  private

  def redirect_logged_in_user
    if logged_in?
      redirect_to tasks_path, alert: 'ログアウトしてください'
    end
  end
end

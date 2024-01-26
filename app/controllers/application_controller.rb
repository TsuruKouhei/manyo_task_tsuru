class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required

  private

  def login_required
    unless current_user
      flash[:notice] = "ログインしてください"
      redirect_to new_session_path
    end
  end

  def check_admin
    unless current_user&.admin?
      redirect_to root_path, alert: '管理者以外アクセスできません'
    end
  end

end

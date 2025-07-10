class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.all
  end


  def promote
    user = User.find(params[:id])
    user.update(admin: true)
    redirect_to admin_users_path, notice: "#{user.email} promoted to admin!"
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end

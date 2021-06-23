class AccountActivationsController < ApplicationController
  before_action :find_user, only: [:edit]
  def edit
    if !@user.activated && @user.authenticated?(:activation, params[:id])
      @user.activate
      flash[:success] = t("acc_activated")
      redirect_to login_url
    else
      flash[:danger] = t("invalid_activation_link")
      redirect_to root_url
    end
  end

  private
  def find_user
    @user = User.find_by email: params[:email]
    return if @user
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end
end

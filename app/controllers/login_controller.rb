class LoginController < ApplicationController

  def index
    if signed_in?
      redirect_to dashboard_path
    end
  end

  def signin
    if (params[:session][:email].strip.blank? || params[:session][:password].strip.blank?)
      flash[:danger] = t('login_error_empty')
      render "index"
    else
      user = User.find_by(email: params[:session][:email].strip.downcase)
      if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_to :dashboard
      else
        flash[:danger] = t('login_error_nouser')
        redirect_to login_index_path
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end

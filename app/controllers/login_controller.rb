class LoginController < ApplicationController

  def new
  end

  def signin
    if (params[:session][:username].strip.blank? || params[:session][:password].strip.blank?)
      flash[:danger] = t('login_error_empty')
      render "index"
    else
      user = User.find_by(username: params[:session][:username].strip.downcase, password: params[:session][:password].strip.downcase)
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

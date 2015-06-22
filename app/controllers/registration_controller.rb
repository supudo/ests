class RegistrationController < ApplicationController

  def index
    @user = User.new
    @technologies = Technology.order("title ASC")
    @positions = Position.order("title ASC")
    @clients = Client.order("title ASC")
  end

  def create
    saved_ok = 0
    if User.exists?(:email => user_params[:email])
      flash[:error] = t('user_already_exists')
    else
      @user = User.new(user_params)
      if @user.save
        flash[:success] =  t('user_created_successfully')
        saved_ok = 1
      end
    end
    if saved_ok == 1
      redirect_to :login_index
    else
      @technologies = Technology.order("title ASC")
      @positions = Position.order("title ASC")
      @clients = Client.order("title ASC")
      render 'index'
    end
  end

  def registration_update_positions
    @positions = Position.where(:technology_id => params[:technology_id])
    respond_to do |format|
      format.js
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password,
                                   :password_confirmation, :technology_id, :position_id,
                                   :client_id, :is_am, :is_pdm)
    end

end

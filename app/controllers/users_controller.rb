class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @technology = Technology.all
    @position = Position.all
    render 'edit'
  end

  def new
    @user = User.new
    @technology = Technology.all
    @position = Position.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = t('welcome_login')
      redirect_to :dashboard
    else
      @technology = Technology.all
      @position = Position.all
      render 'new'
    end
  end

  def edit
    @technology = Technology.all
    @position = Position.all
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_destroyed')
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password, :technology_id, :position_id)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end

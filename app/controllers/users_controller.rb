class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  
  def index
    @users = User.paginate(page: params[:page])
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.users_edit')
    @user = User.find(params[:id])
    @technology = Technology.all
    @position = Position.all
    @client = Client.all
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.users_new')
    @user = User.new
    @technology = Technology.all
    @position = Position.all
    @client = Client.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if signed_in?
        flash[:success] = t('user_created_successfully')
        redirect_to :users
      else
        flash[:success] = t('welcome_login')
        sign_in @user
        redirect_to :dashboard
      end
    else
      @technology = Technology.all
      @position = Position.all
      @client = Client.all
      render 'new'
    end
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.users_edit')
    @technology = Technology.all
    @position = Position.all
    @client = Client.all
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_updated')
      redirect_to @user
    else
      @technology = Technology.all
      @position = Position.all
      @client = Client.all
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
      params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation, :technology_id, :position_id, :client_id)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end

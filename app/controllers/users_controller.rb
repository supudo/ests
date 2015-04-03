class UsersController < ApplicationController
  before_action :signed_in_user
  
  def index
    @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @user = User.find(params[:id])
    @technology = Technology.order("title ASC")
    @position = Position.order("title ASC")
    @client = Client.order("title ASC")
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @user = User.new
    @technology = Technology.order("title ASC")
    @position = Position.order("title ASC")
    @client = Client.order("title ASC")
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
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @user = User.find_by_id(params[:id])
    @technology = Technology.order("title ASC")
    @position = Position.order("title ASC")
    @client = Client.order("title ASC")
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_updated')
      redirect_to :users
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
      params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation,
        :technology_id, :position_id, :client_id, :is_am, :is_pdm)
    end

    def self.permission
      return "Users"
    end

end

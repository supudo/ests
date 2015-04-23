class UsersController < ApplicationController
  before_action :signed_in_user
  autocomplete :user, :searchname, :full => true

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    if params[:ftid] != nil && params[:ftid] != '0'
      @users = User.where("technology_id = ?", params[:ftid]).order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
    else
      @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
    end
    @technology = Technology.order("title ASC")
  end

  def show
    if params.has_key?(:term)
      @users = User.where("username LIKE (?) OR first_name LIKE (?) OR last_name LIKE (?)", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%").order("first_name ASC, last_name")
      respond_to do |format|
        format.json {render json: @users.map { |user| {:id => user.id, :label => user.searchname, :value => user.searchname} }}
      end
    else
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      @user = User.find(params[:id])
      @technology = Technology.order("title ASC")
      @position = Position.order("title ASC")
      @client = Client.order("title ASC")
      render 'edit'
    end
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
    if User.exists?(:username => user_params[:username])
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      flash[:success] = t('user_already_exists')
      redirect_to :new_user
    else
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
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        @technology = Technology.all
        @position = Position.all
        @client = Client.all
        flash[:error] = t('error_missing_fields')
        render 'new'
      end
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
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_updated')
      redirect_to :users
    else
      @technology = Technology.all
      @position = Position.all
      @client = Client.all
      flash[:error] = t('error_missing_fields')
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_destroyed')
    respond_to do |format|
      @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      format.js
    end
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

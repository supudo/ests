class UsersController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    @filterrific = initialize_filterrific(
      User,
      params[:filterrific],
      :select_options => {
        sorted_by: User.options_for_sorted_by
      }
    ) or return
    @users = @filterrific.find.page(params[:page])
    
    if params[:ftid] != nil && params[:ftid] != '0'
      @users = @users.where("technology_id = ?", params[:ftid])
    end

    @users = @users.order("first_name ASC, last_name ASC")

    @user = User.new
    @technologies = Technology.order("title ASC")
    @positions = Position.order("title ASC")
    @clients = Client.order("title ASC")

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('profile')
    @technology = Technology.all
    @position = Position.all
    @client = Client.all
  end

  def show
    if params.has_key?(:term)
      @users = User.where("username LIKE (?) OR first_name LIKE (?) OR last_name LIKE (?)", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%").order("first_name ASC, last_name")
      respond_to do |format|
        format.json {render json: @users.map { |user| {:id => user.id, :label => user.full_name, :value => user.full_name} }}
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

  def create
    if User.exists?(:username => user_params[:username])
      @notif_type = 'warning'
      @notif_message = t('user_already_exists')
    else
      @user = User.new(user_params)
      if @user.save
        if signed_in?
          @notif_type = 'success'
          @notif_message = t('user_created_successfully')
        else
          flash[:success] = t('welcome_login')
          sign_in @user
          redirect_to :dashboard
        end
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
    end
    respond_to do |format|
      if params[:ftid] != nil && params[:ftid] != '0'
        @users = User.where("technology_id = ?", params[:ftid]).order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      else
        @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      end
      @user = User.new
      @technology = Technology.order("title ASC")
      @position = Position.order("title ASC")
      @client = Client.order("title ASC")
      format.js
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      @notif_type = 'success'
      @notif_message = t('profile_updated')
    else
      @notif_type = 'danger'
      @notif_message = t('error_missing_fields')
    end
    respond_to do |format|
      if params[:ftid] != nil && params[:ftid] != '0'
        @users = User.where("technology_id = ?", params[:ftid]).order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      else
        @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      end
      @item_id = @user.id
      @technology = Technology.order("title ASC")
      @position = Position.order("title ASC")
      @client = Client.order("title ASC")
      format.js
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_destroyed')
    respond_to do |format|
      @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page], :per_page => 10)
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  def users_update_positions
    @positions = Position.where(:technology_id => params[:technology_id])
    @item_id = params[:item_id]
    respond_to do |format|
      format.js
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation, :technology_id, :position_id, :client_id, :is_am, :is_pdm)
    end

    def self.permission
      return "Users"
    end

end

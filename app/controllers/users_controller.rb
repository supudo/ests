class UsersController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("users")
  end
  
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
    @technologies = Technology.where(:parent_id => 0).order("title ASC")
    @positions = Position.order("title ASC")
    @clients = Client.order("title ASC")

    @permissions = Permission.order("id ASC")

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('profile')
    @user = @current_user
    @technologies = Technology.where(:parent_id => 0).order("title ASC")
    @positions = Position.all
    @clients = Client.all
    @utechnologies_ids = ','
    @utechnologies_titles = ''
    ucomps = UsersCompetency.where(:user_id => @user.id)
    ucomps.each do |uc|
      @utechnologies_ids += uc.technology_id.to_s + ','
      @utechnologies_titles += "{value: '" + uc.technology_id.to_s + "', label: '" + uc.technology.tree_title + "'},"
    end
    @utechnologies_titles = @utechnologies_titles[0, @utechnologies_titles.size]
  end

  def show
    if params.has_key?(:term)
      @users = User.where("email LIKE (?) OR first_name LIKE (?) OR last_name LIKE (?)", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%").order("first_name ASC, last_name")
      respond_to do |format|
        format.json {render json: @users.map { |user| {:id => user.id, :label => user.full_name, :value => user.full_name} }}
      end
    else
      add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
      add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
      add_breadcrumb I18n.t('breadcrumbs.edit')
      @user = User.find(params[:id])
      @technologies = Technology.where(:parent_id => 0).order("title ASC")
      @positions = Position.order("title ASC")
      @clients = Client.order("title ASC")
      @utechnologies_ids = ','
      @utechnologies_titles = ''
      ucomps = UsersCompetency.where(:user_id => @user.id)
      ucomps.each do |uc|
        @utechnologies_ids += uc.technology_id.to_s + ','
        @utechnologies_titles += "{value: '" + uc.technology_id.to_s + "', label: '" + uc.technology.tree_title + "'},"
      end
      @utechnologies_titles = @utechnologies_titles[0, @utechnologies_titles.size]
      render 'edit'
    end
  end

  def create
    if User.exists?(:email => user_params[:email])
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
      @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page])
      if params[:ftid] != nil && params[:ftid] != '0'
        @users = @users.where("technology_id = ?", params[:ftid])
      end
      @user = User.new
      @technologies = Technology.where(:parent_id => 0).order("title ASC")
      @positions = Position.order("title ASC")
      @clients = Client.order("title ASC")
      format.js
    end
  end

  def update
    has_errors = false
    @user = User.find_by_id(params[:id])
    @user.first_name = user_params[:first_name]
    @user.last_name = user_params[:last_name]
    @user.email = user_params[:email]
    @user.technology_id = user_params[:technology_id]
    @user.position_id = user_params[:position_id]
    @user.client_id = user_params[:client_id]
    @user.is_am = user_params[:is_am]
    @user.is_pdm = user_params[:is_pdm]
    if !user_params[:password].empty? && !user_params[:password_confirmation].empty?
      if user_params[:password] != user_params[:password_confirmation]
        has_errors = true
        @notif_message = t('passwords_not_matching')
      else
        @user.password = user_params[:password]
        @user.password_confirmation = user_params[:password_confirmation]
      end
    end
    UsersCompetency.delete_all(:user_id => @user.id)
    ActiveRecord::Base.transaction do
      tc = user_params[:tech_competencies].split(',')
      tc.uniq.each do |tech|
        if tech != ''
          uc = UsersCompetency.new
          uc.user_id = @user.id
          uc.technology_id = tech
          uc.save
        end
      end
    end
    if has_errors == true
      @current_user = @user
      render 'edit'
    else
      redirect_to :users
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_destroyed')
    respond_to do |format|
      @users = User.order("first_name ASC, last_name ASC").paginate(page: params[:page])
      if params[:ftid] != nil && params[:ftid] != '0'
        @users = @users.where("technology_id = ?", params[:ftid])
      end
      @technologies = Technology.where(:parent_id => 0).order("title ASC")
      @positions = Position.order("title ASC")
      @clients = Client.order("title ASC")
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
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :technology_id, :position_id, :client_id, :is_am, :is_pdm, :tech_competencies)
    end

    def self.permission
      return "Users"
    end

end

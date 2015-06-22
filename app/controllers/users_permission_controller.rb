class UsersPermissionController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("users")
  end

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.users_index'), users_path
    add_breadcrumb I18n.t('breadcrumbs.permissions_index')
    @user = User.find(params[:user_id])
    @permissions = Permission.order("id ASC")
    @user_permissions = UsersPermission.where(:user_id => params[:user_id])
  end

  def create
    if params[:permission_ids].present?
      UsersPermission.delete_all(:user_id => params[:user_id])
      params[:permission_ids].each do |key, permission_id|
        UsersPermission.create(:user_id => params[:user_id], :permission_id => permission_id)
      end
      redirect_to(:back)
    end
  end

end

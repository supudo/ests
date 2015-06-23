class UsersPermissionController < ApplicationController
  before_filter do |controller|
    controller.signed_in_user_permission("users")
  end

  def create
    if params[:permission_ids].present?
      UsersPermission.delete_all(:user_id => params[:user_id])
      params[:permission_ids].each do |key, permission_id|
        UsersPermission.create(:user_id => params[:user_id], :permission_id => permission_id)
      end
    end
    respond_to do |format|
      @users = User.order("first_name ASC, last_name ASC")
      if params[:ftid] != nil && params[:ftid] != '0'
        @users = @users.where("technology_id = ?", params[:ftid])
      end

      @user_id = params[:user_id]
      @notif_type = 'success'
      @notif_message = t('permissions_updated')
      format.html
      format.js
    end
  end

end

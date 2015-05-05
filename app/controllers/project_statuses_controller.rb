class ProjectStatusesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), :project_statuses_path
    @project_status = ProjectStatus.new
    @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 100)
  end

  def create
    if ProjectStatus.exists?(:title => project_statuses_params[:title])
      @notif_type = 'info'
      @notif_message = t('project_status_already_exists')
    else
      ActiveRecord::Base.transaction do
        @project_status = ProjectStatus.new(project_statuses_params)
        if @project_status.save
          @notif_type = 'success'
          @notif_message = t('project_status_created_successfully')
        else
          @notif_type = 'danger'
          @notif_message = t('error_missing_fields')
        end
      end
    end
    respond_to do |format|
      @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 100)
      format.js
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @project_status = ProjectStatus.find_by_id(params[:id])
      if @project_status.update_attributes(project_statuses_params)
        @notif_type = 'success'
        @notif_message = t('project_status_updated_successfully')
      else
        @notif_type = 'danger'
        @notif_message = t('error_missing_fields')
      end
      respond_to do |format|
        @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 100)
        @item_id = @project_status.id
        format.js
      end
    end
  end

  def destroy
    @current = ProjectStatus.find(params[:id])
    pid = @current.id
    ProjectStatus.find(params[:id]).destroy
    respond_to do |format|
      @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 100)
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def project_statuses_params
      params.require(:project_status).permit(:title)
    end
end

class ProjectStatusesController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), project_statuses_path
    @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), project_statuses_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @project_status = ProjectStatus.new
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), project_statuses_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @project_status = ProjectStatus.find(params[:id])
    render 'edit'
  end

  def create
    if ProjectStatus.exists?(:title => project_statuses_params[:title])
      flash[:success] = t('project_status_already_exists')
      redirect_to :new_project
    else
      ActiveRecord::Base.transaction do
        @project_status = ProjectStatus.new(project_statuses_params)
        if @project_status.save
          flash[:success] = t('project_status_created_successfully')
          redirect_to :collections
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), project_statuses_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          @project_status = ProjectStatus.new
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @project_status = ProjectStatus.find_by_id(params[:id])
      if @project_status.update_attributes(project_statuses_params)
        flash[:success] = t('project_status_updated_successfully')
        redirect_to :collections
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.project_statuses_index'), project_statuses_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        @project_status = ProjectStatus.new
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    @current = ProjectStatus.find(params[:id])
    pid = @current.id
    ProjectStatus.find(params[:id]).destroy
    respond_to do |format|
      @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 10)
      format.js
    end
  end

  private

    def project_statuses_params
      params.require(:project_status).permit(:title)
    end
end

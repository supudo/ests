class ProjectsController < ApplicationController
  before_action :signed_in_user

  def index
    @projects = Project.paginate(page: params[:page], :per_page => 10)
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
    add_breadcrumb I18n.t('breadcrumbs.edit')
    @project = Project.find(params[:id])
    @clients = Client.all
    @project_statuses = ProjectStatus.all
    @ams = User.where(:is_am => '1')
    @pdms = User.where(:is_pdm => '1')
    @users = User.all
    @technologies = Technology.order("title ASC")
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @project = Project.new
    @clients = Client.all
    @project_statuses = ProjectStatus.all
    @ams = User.where(:is_am => '1')
    @pdms = User.where(:is_pdm => '1')
    @users = User.all
    @technologies = Technology.order("title ASC")
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = t('project_created_successfully')
      redirect_to :projects
    else
      render 'new'
    end
  end

  def update
    @project = Project.find_by_id(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = t('project_updated_successfully')
      redirect_to :projects
    else
      render 'edit'
    end
  end

  def destroy
    Project.find(params[:id]).destroy
    flash[:success] = t('project_destroyed')
    redirect_to :projects
  end

  private

    def project_params
      params.require(:project).permit(:title, :client_id, :project_status_id,  :account_manager_user_id,
          :production_manager_user_id, :project_owner_user_id, :start_date_scheduled, :start_date_actual,
          :end_date_scheduled, :end_date_actual, :internal_yn, :created_user_id, :created_date,
          :modified_user_id, :modified_date, :rejection_reasons)
    end

end

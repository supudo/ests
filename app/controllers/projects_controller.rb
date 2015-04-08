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
    @clients = Client.order("title ASC")
    @project_statuses = ProjectStatus.order("title ASC")
    @ams = User.where(:is_am => '1').order("first_name ASC, last_name ASC")
    @pdms = User.where(:is_pdm => '1').order("first_name ASC, last_name ASC")
    @users = User.order("first_name ASC, last_name ASC")
    @technologies = Technology.order("title ASC")
    @project_comment = ProjectsComment.where(:project_id => @project.id).order("modified_date DESC").first
    @project_request = ProjectsRequest.where(:project_id => @project.id).order("modified_date DESC").first
    render 'edit'
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
    add_breadcrumb I18n.t('breadcrumbs.new')
    @project = Project.new
    @clients = Client.order("title ASC")
    @project_statuses = ProjectStatus.order("title ASC")
    @ams = User.where(:is_am => '1').order("first_name ASC, last_name ASC")
    @pdms = User.where(:is_pdm => '1').order("first_name ASC, last_name ASC")
    @users = User.order("first_name ASC, last_name ASC")
    @technologies = Technology.order("title ASC")
  end

  def create
    if Project.exists?(:title => project_params[:title])
        flash[:success] = t('project_already_exists')
        redirect_to :new_project
    else
      @project = Project.new(project_params)
      @project.created_user_id = @current_user.id
      @project.created_date = DateTime.now
      @project.modified_user_id = @current_user.id
      @project.modified_date = DateTime.now
      if @project.save
        @project_comment = ProjectsComment.new(:project_id => @project.id,
          :comment => params[:comment],
          :modified_date => Time.now,
          :modified_user_id => @current_user.id)
        @project_comment.save

        @project_request = ProjectsRequest.new(:project_id => @project.id,
          :request => params[:request],
          :modified_date => Time.now,
          :modified_user_id => @current_user.id)
        @project_request.save

        ProjectsTechnology.destroy_all(:project_id => params[:id])
        params[:project][:technology_ids].each do |tech_id|
          ProjectsTechnology.create(:project_id => @project.id, :technology_id => tech_id)
        end

        flash[:success] = t('project_created_successfully')
        redirect_to :projects
      else
        render 'new'
      end
    end
  end

  def update
    @project = Project.find_by_id(params[:id])
    @project.modified_user_id = @current_user.id
    @project.modified_date = DateTime.now
    if @project.update_attributes(project_params)
      @pc = ProjectsComment.find_by(:project_id => params[:id], :comment => params[:comment])
      if @pc.nil?
        @project_comment = ProjectsComment.new(:project_id => params[:id],
          :comment => params[:comment],
          :modified_date => Time.now,
          :modified_user_id => @current_user.id)
        @project_comment.save
      end

      @pr = ProjectsRequest.find_by(:project_id => params[:id], :request => params[:request])
      if @pr.nil?
        @project_request = ProjectsRequest.new(:project_id => params[:id],
          :request => params[:request],
          :modified_date => Time.now,
          :modified_user_id => @current_user.id)
        @project_request.save
      end

      ProjectsTechnology.destroy_all(:project_id => params[:id])
      params[:project][:technology_ids].each do |tech_id|
        ProjectsTechnology.create(:project_id => params[:id], :technology_id => tech_id)
      end

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
          :end_date_scheduled, :end_date_actual, :internal_yn, :rejection_reasons)
    end

end

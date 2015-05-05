class ProjectsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
    @filterrific = initialize_filterrific(
      Project,
      params[:filterrific],
      :select_options => {
        sorted_by: Project.options_for_sorted_by
      }
    ) or return
    @projects = @filterrific.find.page(params[:page]).order("title ASC")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if params.has_key?(:term)
      @projects = Project.where("title LIKE (?)", "%#{params[:term]}%").order("title ASC")
      respond_to do |format|
        format.json {render json: @projects.map { |project| {:id => project.id, :label => project.title, :value => project.title} }}
      end
    else
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
      ActiveRecord::Base.transaction do
        @project = Project.new(project_params)
        @project.created_user_id = @current_user.id
        @project.created_date = DateTime.now
        @project.modified_user_id = @current_user.id
        @project.modified_date = DateTime.now
        if @project.save
          if params[:comment] != ''
            @project_comment = ProjectsComment.new(:project_id => @project.id,
                                                   :comment => params[:comment],
                                                   :modified_date => Time.now,
                                                   :modified_user_id => @current_user.id)
            @project_comment.save
          end

          if params[:request] != ''
            @project_request = ProjectsRequest.new(:project_id => @project.id,
                                                   :request => params[:request],
                                                   :modified_date => Time.now,
                                                   :modified_user_id => @current_user.id)
            @project_request.save
          end

          if params[:project].has_key?([:technology_ids])
            ProjectsTechnology.destroy_all(:project_id => params[:id])
            params[:project][:technology_ids].each do |tech_id|
              ProjectsTechnology.create(:project_id => @project.id, :technology_id => tech_id)
            end
          end

          flash[:success] = t('project_created_successfully')
          redirect_to :projects
        else
          add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
          add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
          add_breadcrumb I18n.t('breadcrumbs.new')
          @clients = Client.order("title ASC")
          @project_statuses = ProjectStatus.order("title ASC")
          @ams = User.where(:is_am => '1').order("first_name ASC, last_name ASC")
          @pdms = User.where(:is_pdm => '1').order("first_name ASC, last_name ASC")
          @users = User.order("first_name ASC, last_name ASC")
          @technologies = Technology.order("title ASC")
          flash[:error] = t('error_missing_fields')
          render 'new'
        end
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @project = Project.find_by_id(params[:id])
      @project.modified_user_id = @current_user.id
      @project.modified_date = DateTime.now
      if @project.update_attributes(project_params)
        if params[:comment] != ''
          @pc = ProjectsComment.find_by(:project_id => params[:id], :comment => params[:comment])
          if @pc.nil?
            @project_comment = ProjectsComment.new(:project_id => params[:id],
                                                   :comment => params[:comment],
                                                   :modified_date => Time.now,
                                                   :modified_user_id => @current_user.id)
            @project_comment.save
          end
        end

        if params[:request] != ''
          @pr = ProjectsRequest.find_by(:project_id => params[:id], :request => params[:request])
          if @pr.nil?
            @project_request = ProjectsRequest.new(:project_id => params[:id],
                                                   :request => params[:request],
                                                   :modified_date => Time.now,
                                                   :modified_user_id => @current_user.id)
            @project_request.save
          end
        end

        if params[:project].has_key?([:technology_ids])
          ProjectsTechnology.destroy_all(:project_id => params[:id])
          params[:project][:technology_ids].each do |tech_id|
            ProjectsTechnology.create(:project_id => @project.id, :technology_id => tech_id)
          end
        end

        flash[:success] = t('project_updated_successfully')
        redirect_to :projects
      else
        add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
        add_breadcrumb I18n.t('breadcrumbs.projects_index'), projects_path
        add_breadcrumb I18n.t('breadcrumbs.edit')
        @clients = Client.order("title ASC")
        @project_statuses = ProjectStatus.order("title ASC")
        @ams = User.where(:is_am => '1').order("first_name ASC, last_name ASC")
        @pdms = User.where(:is_pdm => '1').order("first_name ASC, last_name ASC")
        @users = User.order("first_name ASC, last_name ASC")
        @technologies = Technology.order("title ASC")
        @project_comment = ProjectsComment.where(:project_id => @project.id).order("modified_date DESC").first
        @project_request = ProjectsRequest.where(:project_id => @project.id).order("modified_date DESC").first
        flash[:error] = t('error_missing_fields')
        render 'edit'
      end
    end
  end

  def destroy
    @current = Project.find(params[:id])
    pid = @current.id
    Project.find(params[:id]).destroy
    respond_to do |format|
      @projects = Project.paginate(page: params[:page], :per_page => 10)
      @notif_type = 'info'
      @notif_message = t('delete_sucess')
      format.js
    end
  end

  private

    def project_params
      params.require(:project).permit(:title, :client_id, :project_status_id,  :account_manager_user_id,
                                      :production_manager_user_id, :project_owner_user_id, :start_date_scheduled, :start_date_actual,
                                      :end_date_scheduled, :end_date_actual, :internal_yn, :rejection_reasons)
    end

end

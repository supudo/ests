class RequesthistoryController < ApplicationController
  before_action :signed_in_user

  def show
    @project = Project.find_by_id(params[:id])

    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.projects_index'), :projects_path
    add_breadcrumb @project.title, @project
    add_breadcrumb I18n.t('requests_history')

    @requests = ProjectsRequest.where(:project_id => params[:id]).order("id DESC").paginate(page: params[:page])

    render 'index'
  end

end

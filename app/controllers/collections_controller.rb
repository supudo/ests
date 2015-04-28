class CollectionsController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    add_breadcrumb I18n.t('breadcrumbs.collections_index'), :collections_path
    @technologies = Technology.order("title ASC").paginate(page: params[:page], :per_page => 10)
    @project_statuses = ProjectStatus.order("title ASC").paginate(page: params[:page], :per_page => 10)
    @positions = Position.order("title ASC").paginate(page: params[:page], :per_page => 10)
  end

end

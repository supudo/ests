class DashboardController < ApplicationController
  before_action :signed_in_user

  def index 
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path
    @estimates = Estimate.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @projects = Project.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @clients = Client.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @users = User.order("created_date DESC").paginate(page: 1, :per_page => 10)
  end

end

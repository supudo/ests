class DashboardController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path

    @estimates = Estimate.order("created_date DESC").paginate(page: 1, :per_page => 50)
    @estimates_months = @estimates.group_by { |t| t.created_date.beginning_of_month }

    @projects = Project.order("created_date DESC").paginate(page: 1, :per_page => 50)
    @projects_months = @projects.group_by { |t| t.created_date.beginning_of_month }

    @clients = Client.order("created_date DESC").paginate(page: 1, :per_page => 50)
    @clients_months = @clients.group_by { |t| t.created_date.beginning_of_month }

    @users = User.order("created_date DESC").paginate(page: 1, :per_page => 50)
    @users_months = @users.group_by { |t| t.created_date.beginning_of_month }
  end

end

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

    @stats_projects_per_clients = ActiveRecord::Base.connection.execute("SELECT c.title AS client, COUNT(p.id) AS projects FROM clients AS c INNER JOIN projects AS p ON p.client_id = c.id GROUP BY c.id ORDER BY p.created_date DESC LIMIT 0, 10")
    @estimates_per_clients = ActiveRecord::Base.connection.execute("SELECT c.title AS client, COUNT(e.id) AS estimates FROM clients AS c INNER JOIN projects AS p ON p.client_id = c.id INNER JOIN estimates AS e ON e.project_id = p.id GROUP BY c.id ORDER BY e.created_date DESC LIMIT 0, 10")
    @technologies_per_projects = ActiveRecord::Base.connection.execute("SELECT t.title AS technology, COUNT(DISTINCT pt.project_id) AS projects FROM projects_technologies AS pt INNER JOIN technologies AS t ON t.id = pt.technology_id GROUP BY t.title ORDER BY t.title")
    @technologies_per_users = ActiveRecord::Base.connection.execute("SELECT t.title, count(u.id) FROM technologies AS t INNER JOIN users AS u ON u.technology_id = t.id GROUP BY t.id ORDER BY t.title")
  end

end

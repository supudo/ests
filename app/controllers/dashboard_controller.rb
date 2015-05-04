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
    @technologies_per_estimates = ActiveRecord::Base.connection.execute("SELECT t.title, count(el.id) FROM technologies AS t INNER JOIN estimates_lines AS el ON el.technology_id = t.id GROUP BY t.id ORDER BY t.title")
    @users_per_estimates = ActiveRecord::Base.connection.execute("SELECT CONCAT(u.first_name, ' ', u.last_name) AS 'user', count(e.id) FROM users AS u INNER JOIN estimates AS e ON e.created_user_id = u.id GROUP BY u.id ORDER BY u.username")
    @time_per_technology_min = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(el.hours_min) AS time FROM estimates_lines AS el INNER JOIN technologies AS t ON t.id = el.technology_id GROUP BY el.technology_id")
    @time_per_technology_max = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(el.hours_max) AS time FROM estimates_lines AS el INNER JOIN technologies AS t ON t.id = el.technology_id GROUP BY el.technology_id")
    @price_per_technology_min = ActiveRecord::Base.connection.execute("SELECT t.title, CONCAT(SUM(rp.hourly_rate * el.hours_min), ' ', c.symbol) AS rate FROM rates_prices AS rp INNER JOIN estimates AS e ON e.rate_id = rp.rate_id AND rp.engagement_model_id = e.engagement_model_id INNER JOIN estimates_lines AS el ON el.estimate_id = e.id AND el.position_id = rp.position_id AND el.technology_id = rp.technology_id INNER JOIN technologies AS t ON t.id = rp.technology_id INNER JOIN rates AS r ON r.id = e.rate_id INNER JOIN currencies AS c ON c.id = r.currency_id GROUP BY el.technology_id")
    @price_per_technology_max = ActiveRecord::Base.connection.execute("SELECT t.title, CONCAT(SUM(rp.hourly_rate * el.hours_max), ' ', c.symbol) AS rate FROM rates_prices AS rp INNER JOIN estimates AS e ON e.rate_id = rp.rate_id AND rp.engagement_model_id = e.engagement_model_id INNER JOIN estimates_lines AS el ON el.estimate_id = e.id AND el.position_id = rp.position_id AND el.technology_id = rp.technology_id INNER JOIN technologies AS t ON t.id = rp.technology_id INNER JOIN rates AS r ON r.id = e.rate_id INNER JOIN currencies AS c ON c.id = r.currency_id GROUP BY el.technology_id")
  end

end

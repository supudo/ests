class DashboardController < ApplicationController
  before_action :signed_in_user

  def index
    add_breadcrumb I18n.t('breadcrumbs.dashboard'), :dashboard_path

    @estimates = Estimate.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @estimates_months = @estimates.group_by { |t| t.created_date.beginning_of_month }

    @projects = Project.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @projects_months = @projects.group_by { |t| t.created_date.beginning_of_month }

    @clients = Client.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @clients_months = @clients.group_by { |t| t.created_date.beginning_of_month }

    @users = User.order("created_date DESC").paginate(page: 1, :per_page => 10)
    @users_months = @users.group_by { |t| t.created_date.beginning_of_month }

    @tech_expertise = []
    @technologies = Technology.order("title ASC")
    @technologies.each do |tech|
      tdata = ActiveRecord::Base.connection.execute("SELECT title, users_count FROM (SELECT p.title, p.complexity, (SELECT COUNT(id) FROM users WHERE position_id = p.id AND technology_id = t.id) AS users_count FROM technologies AS t INNER JOIN positions AS p ON p.technology_id = t.id WHERE t.id = " + tech.id.to_s + ") AS t WHERE users_count > 0 ORDER BY title, complexity")
      if (tdata.count > 0)
        data = {:title => tech.title, :data => tdata}
        @tech_expertise.push(data)
      end
    end

    @stats_projects_per_clients = ActiveRecord::Base.connection.execute("SELECT c.title AS client, COUNT(p.id) AS projects FROM clients AS c INNER JOIN projects AS p ON p.client_id = c.id GROUP BY c.id ORDER BY p.created_date DESC LIMIT 0, 10")
    @estimates_per_clients = ActiveRecord::Base.connection.execute("SELECT c.title AS client, COUNT(e.id) AS estimates FROM clients AS c INNER JOIN projects AS p ON p.client_id = c.id INNER JOIN estimates AS e ON e.project_id = p.id GROUP BY c.id ORDER BY e.created_date DESC LIMIT 0, 10")
    @technologies_per_projects = ActiveRecord::Base.connection.execute("SELECT t.title AS technology, COUNT(DISTINCT pt.project_id) AS projects FROM projects_technologies AS pt INNER JOIN technologies AS t ON t.id = pt.technology_id WHERE t.is_rated = 1 GROUP BY t.title ORDER BY t.title")
    @technologies_per_users = ActiveRecord::Base.connection.execute("SELECT t.title, count(u.id) FROM technologies AS t INNER JOIN users AS u ON u.technology_id = t.id WHERE t.is_rated = 1 GROUP BY t.id ORDER BY t.title")
    @technologies_per_estimates = ActiveRecord::Base.connection.execute("SELECT t.title, count(el.id) FROM technologies AS t INNER JOIN estimates_lines AS el ON el.technology_id = t.id WHERE t.is_rated = 1 GROUP BY t.id ORDER BY t.title")
    @users_per_estimates = ActiveRecord::Base.connection.execute("SELECT CONCAT(u.first_name, ' ', u.last_name) AS 'user', count(e.id) FROM users AS u INNER JOIN estimates AS e ON e.owner_user_id = u.id GROUP BY u.id ORDER BY u.email")
    @time_per_technology_min = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(el.hours_min) AS time FROM estimates_lines AS el INNER JOIN technologies AS t ON t.id = el.technology_id WHERE t.is_rated = 1 GROUP BY el.technology_id")
    @time_per_technology_max = ActiveRecord::Base.connection.execute("SELECT t.title, SUM(el.hours_max) AS time FROM estimates_lines AS el INNER JOIN technologies AS t ON t.id = el.technology_id WHERE t.is_rated = 1 GROUP BY el.technology_id")
    @price_per_technology_min = ActiveRecord::Base.connection.execute("SELECT t.title, CONCAT(SUM(rp.hourly_rate * el.hours_min), ' ', c.symbol) AS rate FROM rates_prices AS rp INNER JOIN estimates AS e ON e.rate_id = rp.rate_id AND rp.engagement_model_id = e.engagement_model_id INNER JOIN estimates_lines AS el ON el.estimate_id = e.id AND el.position_id = rp.position_id AND el.technology_id = rp.technology_id INNER JOIN technologies AS t ON t.id = rp.technology_id INNER JOIN rates AS r ON r.id = e.rate_id INNER JOIN currencies AS c ON c.id = r.currency_id WHERE t.is_rated = 1 GROUP BY el.technology_id")
    @price_per_technology_max = ActiveRecord::Base.connection.execute("SELECT t.title, CONCAT(SUM(rp.hourly_rate * el.hours_max), ' ', c.symbol) AS rate FROM rates_prices AS rp INNER JOIN estimates AS e ON e.rate_id = rp.rate_id AND rp.engagement_model_id = e.engagement_model_id INNER JOIN estimates_lines AS el ON el.estimate_id = e.id AND el.position_id = rp.position_id AND el.technology_id = rp.technology_id INNER JOIN technologies AS t ON t.id = rp.technology_id INNER JOIN rates AS r ON r.id = e.rate_id INNER JOIN currencies AS c ON c.id = r.currency_id WHERE t.is_rated = 1 GROUP BY el.technology_id")

    @users_per_technology = ActiveRecord::Base.connection.execute("SELECT t.title, COUNT(u.id) AS users_count FROM users AS u INNER JOIN technologies AS t ON t.id = u.technology_id WHERE t.is_rated = 1 GROUP BY u.technology_id")
    @users_positions = ActiveRecord::Base.connection.execute("SELECT p.title, COUNT(u.position_id) FROM users AS u INNER JOIN positions AS p ON p.id = u.position_id INNER JOIN technologies AS t ON t.id = p.technology_id WHERE t.is_rated = 1 GROUP BY p.title")
    @technology_expertise = ActiveRecord::Base.connection.execute(%{SELECT
  title_technology,
  IFNULL(SUM(coef) / technology_count, 0) AS expertise,
  technology_count,
  max_complexity
FROM
(
  SELECT
    id_technology,
    title_technology,
    complexity,
    positions_count,
    technology_count,
    complexity * positions_count AS coef,
    max_complexity
  FROM
  (
    SELECT
      t.id AS id_technology,
      t.title AS title_technology,
      p.title AS title_position,
      p.complexity,
      (SELECT COUNT(id) FROM users WHERE position_id = p.id) AS positions_count,
      (SELECT COUNT(id) FROM users WHERE technology_id = t.id) AS technology_count,
      (SELECT MAX(complexity) FROM positions WHERE technology_id = t.id) AS max_complexity
    FROM
      technologies AS t
      INNER JOIN positions AS p ON p.technology_id = t.id
    WHERE
      t.is_rated = 1
  ) AS t
) AS t2
GROUP BY
  title_technology})

    @estimates_signed_unsigned = ActiveRecord::Base.connection.execute("SELECT CASE WHEN is_signed = 0 THEN 'Unsigned' ELSE 'Signed' END AS signed_yn, COUNT(is_signed) AS cond_count FROM estimates GROUP BY is_signed")
    @estimates_per_month = ActiveRecord::Base.connection.execute(%{SELECT
  DATE_FORMAT(created_date, '%M, %Y') AS estimate_month,
  COUNT(id) AS estimates_count
FROM
  estimates
WHERE
  DATE_SUB(NOW(), INTERVAL 1 YEAR) < created_date
GROUP BY
  estimate_month})
  end

end

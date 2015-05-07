class Project < ActiveRecord::Base
  has_many :projects_comments, :dependent => :destroy
  has_many :projects_requests, :dependent => :destroy
  has_many :project_technologies, :dependent => :destroy, :class_name => 'ProjectsTechnology'
  has_many :technologies, :through => :project_technologies
  has_one :client, class_name: "Client", foreign_key: "client_id"

  self.per_page = 30

  validates :title, presence: true
  validates :client_id, :numericality => { :greater_than => 0 }
  validates :project_status_id, presence: true, :numericality => { :greater_than => 0 }
  validates :account_manager_user_id, presence: true, :numericality => { :greater_than => 0 }

  def account_manager_email
    @user = User.find_by(:id => account_manager_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def account_manager_name
    @user = User.find_by(:id => account_manager_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

  def production_manager_email
    @user = User.find_by(:id => production_manager_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def project_owner_email
    @user = User.find_by(:id => project_owner_user_id)
    if !@user.nil?
      @user.username
    end
  end

  def project_owner_name
    @user = User.find_by(:id => project_owner_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

  def production_manager_name
    @user = User.find_by(:id => production_manager_user_id)
    if !@user.nil?
      @user.first_name + ' ' + @user.last_name
    end
  end

  filterrific(
    default_filter_params: { sorted_by: 'title ASC' },
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  scope :search_query, lambda { |query|
    return nil if query.blank?
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conditions = 12
    where(
      terms.map {
        or_clauses = [
          "LOWER(projects.title) LIKE CONCAT('%', ?, '%')",
          "(SELECT 1 FROM clients WHERE id = projects.client_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))",
          "(SELECT 1 FROM project_statuses WHERE id = projects.project_status_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))",
          "(SELECT 1 FROM users WHERE id = projects.account_manager_user_id AND (LOWER(username) LIKE CONCAT('%', ?, '%') OR LOWER(first_name) LIKE CONCAT('%', ?, '%') OR LOWER(last_name) LIKE CONCAT('%', ?, '%')))",
          "(SELECT 1 FROM users WHERE id = projects.production_manager_user_id AND (LOWER(username) LIKE CONCAT('%', ?, '%') OR LOWER(first_name) LIKE CONCAT('%', ?, '%') OR LOWER(last_name) LIKE CONCAT('%', ?, '%')))",
          "(SELECT 1 FROM users WHERE id = projects.project_owner_user_id AND (LOWER(username) LIKE CONCAT('%', ?, '%') OR LOWER(first_name) LIKE CONCAT('%', ?, '%') OR LOWER(last_name) LIKE CONCAT('%', ?, '%')))"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e|
       [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^title/
        order("projects.title #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [['Title (a-z)', 'title_asc']]
  end

end

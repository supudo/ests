class User < ActiveRecord::Base
  belongs_to :position
  belongs_to :technology
  has_many :clients
  has_many :users_permissions
  has_many :permissions, :through => :users_permissions
  has_many :estimates, class_name: 'Estimate', inverse_of: :owner_user

  self.per_page = 30

  before_save { self.email = email.to_s.downcase }
  before_create :create_remember_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  validates_presence_of :password, :on => :create
  validates_confirmation_of :password, :allow_blank => true
  validates_length_of :password, :within => 6..40, :allow_blank => true

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def fullname_email
    "#{first_name} #{last_name} (#{email})"
  end

  def position_technology
    "#{position.title} #{technology.title}"
  end

  filterrific(
    default_filter_params: { sorted_by: '' },
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
    num_or_conditions = 5
    where(
      terms.map {
        or_clauses = [
          "LOWER(users.first_name) LIKE CONCAT('%', ?, '%')",
          "LOWER(users.last_name) LIKE CONCAT('%', ?, '%')",
          "LOWER(users.email) LIKE CONCAT('%', ?, '%')",
          "(SELECT 1 FROM positions WHERE id = users.position_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))",
          "(SELECT 1 FROM technologies WHERE id = users.technology_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e|
       [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
  }

  def self.options_for_sorted_by
    [['Name (a-z)', 'full_name_asc']]
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end

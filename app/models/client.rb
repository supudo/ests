class Client < ActiveRecord::Base
  has_many :projects
  validates :title, presence: true

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
    num_or_conditions = 4
    where(
      terms.map {
        or_clauses = [
          "LOWER(clients.title) LIKE CONCAT('%', ?, '%')",
          "LOWER(clients.url) LIKE CONCAT('%', ?, '%')",
          "LOWER(clients.email) LIKE CONCAT('%', ?, '%')",
          "LOWER(clients.phone) LIKE CONCAT('%', ?, '%')"
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
        order("clients.title #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [['Title (a-z)', 'title_asc']]
  end
end

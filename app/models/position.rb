class Position < ActiveRecord::Base
  has_many :users
  belongs_to :technology

  self.per_page = 30

  validates :title, presence: true

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
    num_or_conditions = 2
    where(
      terms.map {
        or_clauses = [
          "LOWER(positions.title) LIKE CONCAT('%', ?, '%')",
          "(SELECT 1 FROM technologies WHERE id = positions.technology_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))"
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
    [['Title (a-z)', 'title_asc']]
  end

end

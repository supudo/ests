class Casestudy < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true, :numericality => { :greater_than => 0 }
  validates :title, presence: true

  self.per_page = 30

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
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "LOWER(case_studies.title) LIKE CONCAT('%', ?, '%')"
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

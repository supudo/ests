class Estimate < ActiveRecord::Base
  belongs_to :rate
  belongs_to :engagement_model

  self.per_page = 30

  validates :title, presence: true
  validates :client_id, :numericality => { :greater_than => 0 }
  validates :project_id, presence: true, :numericality => { :greater_than => 0 }

  def total_min_hours
    @lines = EstimatesLine.where(:estimate_id => self.id)
    hours = 0
    @lines.each do |item|
      hours += item.hours_min
    end
    return hours
  end

  def total_max_hours
    @lines = EstimatesLine.where(:estimate_id => self.id)
    hours = 0
    @lines.each do |item|
      hours += item.hours_max
    end
    return hours
  end

  def total_min_price
    rate_prices = RatesPrice.where(:rate_id => self.rate_id, :engagement_model_id => self.engagement_model_id)
    p = 0
    @lines = EstimatesLine.where(:estimate_id => self.id)
    @lines.each do |item|
      rp = rate_prices.where(:technology_id => item.technology_id, :position_id => item.position_id).first
      if rp != nil
        rate_per_hour = rp.hourly_rate
      else
        rate_per_hour = 0
      end
      p += item.hours_min * rate_per_hour
    end
    return p
  end

  def total_max_price
    rate_prices = RatesPrice.where(:rate_id => self.rate_id, :engagement_model_id => self.engagement_model_id)
    p = 0
    @lines = EstimatesLine.where(:estimate_id => self.id)
    @lines.each do |item|
      rp = rate_prices.where(:technology_id => item.technology_id, :position_id => item.position_id).first
      if rp != nil
        rate_per_hour = rp.hourly_rate
      else
        rate_per_hour = 0
      end
      p += item.hours_max * rate_per_hour
    end
    return p
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
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(estimates.title) LIKE CONCAT('%', ?, '%')",
          "(SELECT 1 FROM clients WHERE id = estimates.client_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))",
          "(SELECT 1 FROM projects WHERE id = estimates.project_id AND LOWER(title) LIKE CONCAT('%', ?, '%'))"
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
        order("estimates.title #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [['Title (a-z)', 'title_asc']]
  end

end

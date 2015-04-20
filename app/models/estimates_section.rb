class EstimatesSection < ActiveRecord::Base
  has_many :estimates_line

  validates :title, presence: true

  def total_min_hours
    @lines = EstimatesLine.where(:estimates_sections_id => self.id)
    hours = 0
    @lines.each do |item|
      hours += item.hours_min
    end
    return hours
  end

  def total_max_hours
    @lines = EstimatesLine.where(:estimates_sections_id => self.id)
    hours = 0
    @lines.each do |item|
      hours += item.hours_max
    end
    return hours
  end
end

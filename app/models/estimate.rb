class Estimate < ActiveRecord::Base
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

end

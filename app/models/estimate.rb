class Estimate < ActiveRecord::Base
  belongs_to :rate
  belongs_to :engagement_model

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

end

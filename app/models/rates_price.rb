class RatesPrice < ActiveRecord::Base
  belongs_to :position
  belongs_to :technology

  validates :rate_id, presence: true, :numericality => { :greater_than => 0 }
  validates :engagement_model_id, presence: true, :numericality => { :greater_than => 0 }
  validates :technology_id, presence: true, :numericality => { :greater_than => 0 }
  validates :position_id, presence: true, :numericality => { :greater_than => 0 }
  validates :daily_rate, presence: true
  validates :hourly_rate, presence: true
end

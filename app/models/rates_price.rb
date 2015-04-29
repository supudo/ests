class RatesPrice < ActiveRecord::Base
  validates :rate_id, presence: true, :numericality => { :greater_than => 0 }
  validates :engagement_model_id, presence: true, :numericality => { :greater_than => 0 }
  validates :technology_id, presence: true, :numericality => { :greater_than => 0 }
  validates :profile, presence: true
  validates :daily_rate, presence: true
  validates :hourly_rate, presence: true
end

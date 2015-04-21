class EstimatesLine < ActiveRecord::Base
  belongs_to :technology
  belongs_to :estimate
  belongs_to :estimates_section

  validates :estimate_id, presence: true, :numericality => { :greater_than => 0 }
  validates :estimates_sections_id, presence: true, :numericality => { :greater_than => 0 }
  validates :technology_id, presence: true, :numericality => { :greater_than => 0 }
  validates :line, presence: true
end

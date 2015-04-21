class EstimatesSheet < ActiveRecord::Base
  has_many :estimates_sheet

  validates :estimate_id, presence: true, :numericality => { :greater_than => 0 }

end

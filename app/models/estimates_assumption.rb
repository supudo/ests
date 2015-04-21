class EstimatesAssumption < ActiveRecord::Base
  belongs_to :estimate

  validates :title, presence: true
end

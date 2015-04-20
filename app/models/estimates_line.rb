class EstimatesLine < ActiveRecord::Base
  belongs_to :technology
  belongs_to :estimate
  belongs_to :estimates_section
end

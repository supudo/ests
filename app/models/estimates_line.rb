class EstimatesLine < ActiveRecord::Base
  belongs_to :technology
  belongs_to :estimate
end

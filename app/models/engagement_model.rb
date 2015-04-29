class EngagementModel < ActiveRecord::Base
  validates :title, presence: true
end

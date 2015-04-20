class ProjectStatus < ActiveRecord::Base
  validates :title, presence: true
end

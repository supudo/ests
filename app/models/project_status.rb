class ProjectStatus < ActiveRecord::Base
  validates :title, presence: true
  validates :title, presence: true

  self.per_page = 30
end

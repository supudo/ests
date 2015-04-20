class ProjectsTechnology < ActiveRecord::Base
  belongs_to :project
  belongs_to :technology

  validates :title, presence: true
end

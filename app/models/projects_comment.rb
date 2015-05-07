class ProjectsComment < ActiveRecord::Base
  belongs_to :project
  belongs_to :user, :foreign_key => 'modified_user_id'

  self.per_page = 30
end

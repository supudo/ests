class Project < ActiveRecord::Base
  has_many :projects_comments, :dependent => :destroy
  has_many :projects_requests, :dependent => :destroy
  has_many :project_technologies, :dependent => :destroy, :class_name => 'ProjectsTechnology'
  has_many :technologies, :through => :project_technologies
 
end

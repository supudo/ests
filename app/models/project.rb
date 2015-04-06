class Project < ActiveRecord::Base
  has_many :projects_comments
  has_many :projects_requests
  has_many :projects_technologies
end

class Technology < ActiveRecord::Base
  has_many :user
  has_many :project_technologies, :dependent => :destroy
  has_many :projects, :through => :project_technologies
end

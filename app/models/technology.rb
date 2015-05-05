class Technology < ActiveRecord::Base
  has_many :user
  has_many :projects_technology, :dependent => :destroy
  has_many :projects, :through => :project_technologies

  validates :title, presence: true

  def self.options_for_select
    order('title').map { |e| [e.title, e.id] }
  end
end

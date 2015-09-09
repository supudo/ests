class Technology < ActiveRecord::Base
  has_many :user
  has_many :projects_technology, :dependent => :destroy
  has_many :projects, :through => :project_technologies
  has_many :positions
  has_many :children, class_name: "Technology", foreign_key: "parent_id", :dependent => :destroy
  belongs_to :parent, class_name: "Technology"

  self.per_page = 30

  validates :title, presence: true

  def self.options_for_select
    order('title').map { |e| [e.title, e.id] }
  end

  def self.all_children(children_array = [], parent_id = 0)
    children = Technology.where(parent_id: parent_id)
    children_array += children.all
    children.each do |child|
      child.all_children(children_array, child.id)
    end
    children_array
  end
end

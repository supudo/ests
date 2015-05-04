class Position < ActiveRecord::Base
  has_many :users
  #has_many :technologies
  belongs_to :technology

  validates :title, presence: true

end

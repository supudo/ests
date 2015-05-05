class Position < ActiveRecord::Base
  has_many :users
  belongs_to :technology

  validates :title, presence: true

end

class Position < ActiveRecord::Base
  has_many :users
  has_many :technologies
end

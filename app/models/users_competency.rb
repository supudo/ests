class UsersCompetency < ActiveRecord::Base
  belongs_to :user
  belongs_to :technology
end

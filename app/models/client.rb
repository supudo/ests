class Client < ActiveRecord::Base
  validates :title, presence: true
end

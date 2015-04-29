class Currency < ActiveRecord::Base
  validates :title, presence: true
  validates :code, presence: true
  validates :symbol, presence: true
end

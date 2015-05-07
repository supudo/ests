class Currency < ActiveRecord::Base
  self.per_page = 30

  validates :title, presence: true
  validates :code, presence: true
  validates :symbol, presence: true
end

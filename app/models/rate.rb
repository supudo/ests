class Rate < ActiveRecord::Base
  validates :title, presence: true
  validates :currency_id, presence: true, :numericality => { :greater_than => 0 }
end

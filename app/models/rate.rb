class Rate < ActiveRecord::Base
  belongs_to :currency

  validates :title, presence: true
  validates :currency_id, presence: true, :numericality => { :greater_than => 0 }
end

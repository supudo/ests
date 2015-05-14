class CasestudyChallenge < ActiveRecord::Base
  belongs_to :casestudy

  validates :case_study_id, presence: true, :numericality => { :greater_than => 0 }
  validates :title, presence: true
end

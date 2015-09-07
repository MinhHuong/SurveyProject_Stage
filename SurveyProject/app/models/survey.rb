class Survey < ActiveRecord::Base
  belongs_to :type_survey
  belongs_to :priority
  belongs_to :user
  has_many :finish_surveys
end

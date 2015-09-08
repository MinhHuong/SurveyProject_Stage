class Question < ActiveRecord::Base
  belongs_to :type_question
  belongs_to :survey
  has_many :choices
  has_many :responses
end

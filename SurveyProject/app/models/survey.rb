class Survey < ActiveRecord::Base
  belongs_to :type_survey
  belongs_to :priority
  belongs_to :user
  has_many :finish_surveys
  has_many :questions

  def self.opened
    all.where(:status => true)
  end

  def self.recently_created
    now = Date.today
    one_week_ago = (now-14)
    all.where(:status => true).where(:created_at => one_week_ago.beginning_of_day..now.end_of_day)
  end

  def self.recently_done(user_id)
    all.where(:id => FinishSurvey.recently_done_surveys_of(user_id))
  end

  def self.high_prio
    all.where(:status => true).where(:priority_id => (Priority.where(:name_priority => 'High')))
  end

  def self.closed_today
    now = Date.today
    all.where(:status => true).where(:date_closed => now.beginning_of_day..now.end_of_day)
  end
end

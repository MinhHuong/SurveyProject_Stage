class FinishSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey

  def self.recently_done_surveys_of(user_id)
    now = Date.today
    one_week_ago = (now - 7)
    items = []
    FinishSurvey
        .where(:user_id => user_id)
        .where(:created_at => one_week_ago.beginning_of_day..now.end_of_day)
        .each do |item|
      items << item.survey_id
    end
    items
  end
end

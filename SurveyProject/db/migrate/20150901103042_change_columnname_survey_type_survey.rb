class ChangeColumnnameSurveyTypeSurvey < ActiveRecord::Migration
  def change
    rename_column :surveys, :type_surveys_id, :type_survey_id
  end
end

class RenameColFinishSurveys < ActiveRecord::Migration
  def change
    rename_column :finish_surveys, :users_id, :user_id
    rename_column :finish_surveys, :surveys_id, :survey_id
  end
end

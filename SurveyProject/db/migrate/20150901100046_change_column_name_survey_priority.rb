class ChangeColumnNameSurveyPriority < ActiveRecord::Migration
  def change
    rename_column :surveys, :priorities_id, :priority_id
  end
end

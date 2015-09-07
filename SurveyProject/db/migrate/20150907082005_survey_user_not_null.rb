class SurveyUserNotNull < ActiveRecord::Migration
  def change
    change_column_null :surveys, :user_id, :null => false
  end
end

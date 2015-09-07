class UserSurveyNotNullable < ActiveRecord::Migration
  def change
    change_column_null :surveys, :user_id, false
  end
end

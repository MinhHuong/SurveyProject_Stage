class ChangeColumnnameSurveyUser < ActiveRecord::Migration
  def change
    rename_column :surveys, :users_id, :user_id
  end
end

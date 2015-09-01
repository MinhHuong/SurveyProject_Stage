class ChangeColumnNotNullStatusSurveys < ActiveRecord::Migration
  def change
    change_column_null :surveys, :status, :null => false
  end
end

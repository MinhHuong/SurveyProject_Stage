class AddStatusToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :status, :boolean
  end
end

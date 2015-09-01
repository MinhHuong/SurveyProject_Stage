class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name_survey, null: false
      t.references :type_surveys, null: false
      t.references :priorities, null: false
      t.references :users
      t.timestamp :date_closed, null: false
      t.timestamps
    end
  end
end

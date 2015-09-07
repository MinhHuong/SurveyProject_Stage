class CreateTypeSurveys < ActiveRecord::Migration
  def change
    # drop_table :type_surveys

    create_table :type_surveys do |t|
      t.string :name_type_survey, null: false
    end
  end
end

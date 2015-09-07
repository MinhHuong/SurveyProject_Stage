class CreateFinishSurveys < ActiveRecord::Migration
  def change
    create_table :finish_surveys do |t|
      t.references :users, null: false
      t.references :surveys, null: false
      t.timestamps
    end
  end
end

class CreateTypeQuestions < ActiveRecord::Migration
  def change
    create_table :type_questions do |t|
      t.string :name_type_question, null: false
      t.timestamps
    end
  end
end

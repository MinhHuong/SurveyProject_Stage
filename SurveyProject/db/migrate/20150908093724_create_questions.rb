class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content, null: false
      t.text :link_picture, null: false
      t.references :type_question, null: false
      t.references :survey, null: false
      t.timestamps
    end
  end
end

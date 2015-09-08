class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.text :content, null: false
      t.references :question, null: false
      t.timestamps
    end
  end
end

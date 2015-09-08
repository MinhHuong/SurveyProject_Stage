class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :question, null: false
      t.references :choice, null: false
      t.timestamps
    end
  end
end

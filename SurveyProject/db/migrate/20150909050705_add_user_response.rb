class AddUserResponse < ActiveRecord::Migration
  def change
    drop_table :responses

    create_table :responses do |t|
      t.references :question, null: false
      t.references :choice, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

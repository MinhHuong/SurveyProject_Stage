class CreateLeaders < ActiveRecord::Migration
  def change
    drop_table :leaders

    create_table :leaders do |t|
      t.references :user, null: false
    end
  end
end

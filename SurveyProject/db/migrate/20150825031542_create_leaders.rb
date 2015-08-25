class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.references :user, null: false
    end
  end
end

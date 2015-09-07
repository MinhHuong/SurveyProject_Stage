class CreatePriorities < ActiveRecord::Migration
  def change
    #drop_table :priorities

    create_table :priorities do |t|
      t.string :name_priority, null: false
    end
  end
end

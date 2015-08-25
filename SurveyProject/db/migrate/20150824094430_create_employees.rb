class CreateEmployees < ActiveRecord::Migration
  def change
    # drop_table :employees

    create_table :employees do |t|
      t.references :user, null: false
    end
  end
end

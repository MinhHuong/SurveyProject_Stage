class CreateUsers < ActiveRecord::Migration
  def change
    # drop_table :users

    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :link_picture
      t.date :date_create
      t.references :clients, null: false
    end
  end
end

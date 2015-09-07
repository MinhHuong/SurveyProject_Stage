class CreateUsers < ActiveRecord::Migration
  def change
    # drop_table :users

    create_table :users do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :link_picture
      t.string :permission, null: false
      t.references :clients, null: false
      t.timestamps null: false
    end
  end
end

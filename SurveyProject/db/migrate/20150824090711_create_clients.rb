class CreateClients < ActiveRecord::Migration
  def change
    drop_table :clients

    create_table :clients do |t|
      t.string :name_client, null: false
      t.string :connection_string
      t.timestamps null: false
    end
  end
end

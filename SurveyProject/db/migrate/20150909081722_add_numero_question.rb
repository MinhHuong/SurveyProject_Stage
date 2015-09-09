class AddNumeroQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :numero_question, :integer
  end
end

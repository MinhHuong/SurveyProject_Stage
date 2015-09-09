class AddColumnTypeQuestion < ActiveRecord::Migration
  def change
    add_column  :type_questions, :code_type_question, :string
  end
end

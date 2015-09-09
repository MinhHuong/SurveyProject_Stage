class CodeTypeQuestionNotNull < ActiveRecord::Migration
  def change
    change_column_null :type_questions, :code_type_question, false
  end
end

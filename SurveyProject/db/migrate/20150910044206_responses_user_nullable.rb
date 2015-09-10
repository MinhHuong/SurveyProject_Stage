class ResponsesUserNullable < ActiveRecord::Migration
  def change
    change_column_null :responses, :user_id, true
  end
end

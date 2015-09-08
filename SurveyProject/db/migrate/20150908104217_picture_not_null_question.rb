class PictureNotNullQuestion < ActiveRecord::Migration
  def change
    change_column_null :questions, :link_picture, true
  end
end

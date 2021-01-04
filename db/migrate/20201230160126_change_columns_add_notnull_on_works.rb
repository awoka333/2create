class ChangeColumnsAddNotnullOnWorks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :works, :work_image_id, false
  end
end

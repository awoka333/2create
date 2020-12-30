class AddWorkImageIdToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :work_image_id, :integer
  end
end

class ChangeCloumnWorkImageId < ActiveRecord::Migration[5.2]
  def change
    change_column :works, :work_image_id, :string
  end
end

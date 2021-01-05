class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.integer :act_image_id, null: false
      t.string :to_create, null: false
      t.string :to_study, null: false
      t.string :to_do

      t.timestamps
    end
  end
end

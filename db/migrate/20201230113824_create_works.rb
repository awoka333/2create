class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.integer :user_id
      t.integer :act_id
      t.string :title
      t.string :point
      t.string :creator1
      t.string :creator2
      t.boolean :is_masking

      t.timestamps
    end
  end
end

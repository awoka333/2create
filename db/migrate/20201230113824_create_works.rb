class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.integer :user_id, null: false
      t.integer :act_id, null: false
      t.string :title, null: false
      t.string :point, null: false
      t.string :creator1, null: false
      t.string :creator2
      t.boolean :is_masking, null: false, default: false

      t.timestamps
    end
  end
end

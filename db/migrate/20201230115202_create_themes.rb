class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :month, null: false
      t.string :theme1, null: false
      t.string :theme2, null: false
      t.string :theme3, null: false
      t.text :sentence, null: false
      t.string :theme_image_id, null: false

      t.timestamps
    end
  end
end

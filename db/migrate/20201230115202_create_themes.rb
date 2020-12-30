class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :month
      t.string :theme1
      t.string :theme2
      t.string :theme3
      t.text :theme_sentence
      t.integer :theme_image_id

      t.timestamps
    end
  end
end

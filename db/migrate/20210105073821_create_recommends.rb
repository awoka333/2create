class CreateRecommends < ActiveRecord::Migration[5.2]
  def change
    create_table :recommends do |t|
      t.integer :user_id, null: false
      t.integer :activity_id, null: false

      t.timestamps
    end
  end
end

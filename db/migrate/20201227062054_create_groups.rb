class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :user_id, null: false
      t.integer :act_id, null: false
      t.integer :member_status, null: false, default: 0
      t.integer :graduate_status, null: false, default: 0

      t.timestamps
    end
  end
end

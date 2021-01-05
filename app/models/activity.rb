class Activity < ApplicationRecord

  has_many :groups, dependent: :destroy
  has_many :users, through: :groups
  has_many :users, through: :comments

  has_many :works, dependent: :destroy

  attachment :act_image_id
end

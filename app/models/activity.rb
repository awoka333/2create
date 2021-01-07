class Activity < ApplicationRecord

  has_many :groups, dependent: :destroy
  # has_many :users, through: :groups
  has_many  :group_users, source: :user
  has_many :comments, dependent: :destroy
  # has_many :users, through: :comments
  has_many  :comment_users, source: :user

  has_many :works, dependent: :destroy

  attachment :act_image
end

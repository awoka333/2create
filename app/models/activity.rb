class Activity < ApplicationRecord

  has_many :groups, dependent: :destroy
  # has_many :users, through: :groups
  has_many  :group_users, source: :user
  has_many :comments, dependent: :destroy
  # has_many :users, through: :comments
  has_many  :comment_users, source: :user

  has_many :works, dependent: :destroy

  validates :name, presence: true
  validates :act_image, presence: true
  validates :to_create, presence: true
  validates :to_study, presence: true

  attachment :act_image
end

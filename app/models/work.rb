class Work < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  has_many :favorites, dependent: :destroy
  has_many :works, through: :favorites

  attachment :work_image_id
end

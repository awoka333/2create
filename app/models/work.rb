class Work < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  validates :user_id, presence: true
  validates :activity_id, presence: true
  validates :work_image_id, presence: true
  validates :title, presence: true
  validates :point, presence: true
  validates :creator1, presence: true
  validates :is_masking, presence: true

  attachment :work_image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end

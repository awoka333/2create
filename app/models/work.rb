class Work < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  attachment :work_image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end

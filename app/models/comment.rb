class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true
  validates :sentence, presence: true
  validates :score, numericality: { greater_than_or_equal_to: -0.7 } #スコアが低すぎる場合、コメントを弾く
end

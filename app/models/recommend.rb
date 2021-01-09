class Recommend < ApplicationRecord
  validates :user_id, presence: true
  validates :activity_id, presence: true
end

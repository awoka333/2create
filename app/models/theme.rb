class Theme < ApplicationRecord
  validates :theme_image_id, presence: true
  validates :month, presence: true
  validates :theme1, presence: true
  validates :theme2, presence: true
  validates :theme3, presence: true
  validates :sentence, presence: true

  attachment :theme_image
end

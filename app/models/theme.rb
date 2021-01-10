class Theme < ApplicationRecord
  validates :month, presence: true
  validates :theme1, presence: true
  validates :theme2, presence: true
  validates :theme3, presence: true
  validates :sentence, presence: true

  attachment :theme_image
end

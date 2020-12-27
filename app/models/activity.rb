class Activity < ApplicationRecord

  has_many :groups, dependent: :destroy
  has_many :users, through: :groups
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :groups, dependent: :destroy
  has_many :activities, through: :groups

  has_many :comments, dependent: :destroy
  has_many :activities, through: :comments

  has_many :works
  has_many :favorites, dependent: :destroy
  has_many :works, through: :favorites

  enum status: { 'ユーザー': 0, '管理者': 1 }
end

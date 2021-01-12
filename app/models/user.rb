class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :groups, dependent: :destroy
  has_many :group_activities, source: :activity, through: :groups
  # has_many :activities, through: :groups とすると、comments, recommendsと区別がつかない

  has_many :comments, dependent: :destroy
  has_many :comment_activities, source: :activity, through: :comments
  # has_many :activities, through: :comments とすると、groups, recommendsと区別がつかない

  has_many :recommends, dependent: :destroy
  has_many :recommend_activities, source: :activity, through: :recommends
  # has_many :activities, through: :recommends とすると、groups, commentsと区別がつかない

  has_many :works
  has_many :favorites, dependent: :destroy
  has_many :works, through: :favorites

  validates :name, presence: true
  validates :email, presence: true
  validates :encrypted_password, presence: true, length: { minimum:6 }
  validates :authority, presence: true

  enum authority: { 'ユーザー': 0, '管理者': 99 }
end

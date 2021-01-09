class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :groups, dependent: :destroy
  # has_many :activities, through: :groups とすると、commentsと区別がつかないので下記
  has_many  :group_activities, source: :activity

  has_many :comments, dependent: :destroy
  # has_many :activities, through: :comments とすると、groupsと区別がつかないので下記
  has_many :comment_activities, source: :activity

  has_many :works
  has_many :favorites, dependent: :destroy
  has_many :works, through: :favorites

  validates :name, presence: true
  validates :email, presence: true
  validates :encrypted_password, presence: true, length: { minimum:8 }
  validates :authority, presence: true
  validates :is_deleted, presence: true

  enum status: { 'ユーザー': 0, '管理者': 1 }
end

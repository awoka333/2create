class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  enum member_status: { '承認待ち': 0, 'メンバー': 1, 'リーダー': 2, 'シニア': 3 }, _prefix: true
  enum graduate_status: { '卒業しない':0, '卒業依頼':1, 'シニア':2 }, _prefix: true
end

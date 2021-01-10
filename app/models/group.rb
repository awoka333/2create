class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true

  enum member_status: { '承認待ち': 0, 'メンバー': 1, 'リーダー': 2, 'シニア': 3 }
  enum graduate_status: { '卒業しない': 0, '卒業依頼': 1, '卒業': 2 }

  def update_status(status)
    statuses = {
      # member_statusの返り値
      waiting_accept: '承認待ち',
      accept: 'メンバー',
      leader: 'リーダー',
      senior: 'シニア',
      # graduate_statusの返り値
      no_graduate: '卒業しない',
      pre_graduate: '卒業依頼',
      graduate: '卒業'
    }
    if status.to_sym == :senior
       update(member_status: statuses[status], graduate_status: '卒業')
    elsif status.to_sym == :waiting_accept
      update(member_status: statuses[status])
    elsif status.to_sym == :accept
      update(member_status: statuses[status])
    elsif status.to_sym == :leader
      update(member_status: statuses[status]) # まとめたい
    else
      update(graduate_status: statuses[status])
    end
  end
end

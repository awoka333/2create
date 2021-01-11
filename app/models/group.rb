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
      waiting_accept: 0,
      accept: 1,
      leader: 2,
      senior: 3,
      # graduate_statusの返り値
      no_graduate: 0,
      pre_graduate: 1,
      graduate: 2
    }
    if status.to_sym == :senior
      update(member_status: statuses[status.to_sym], graduate_status: '卒業')
    elsif status.to_sym == :waiting_accept
      update(member_status: statuses[status.to_sym])
    elsif status.to_sym == :accept
      update(member_status: statuses[status.to_sym])
    elsif status.to_sym == :leader
      update(member_status: statuses[status.to_sym]) # まとめたい
    else
      update(graduate_status: statuses[status.to_sym])
    end
  end

  #  1行にまとめる時の記述。可読性は上より低い
  #   if status.to_sym == :senior
  #     update(member_status: statuses[status.to_sym], graduate_status: '卒業')
  #   elsif status.to_sym == :waiting_accept || status.to_sym == :accept || status.to_sym == :leader
  #     status_to_sym(statuses[status.to_sym])
  #   else
  #     update(graduate_status: statuses[status.to_sym]) # 下のメソッドを参照している
  #   end
  # end

  # protected
  # def self.status_to_sym(status)
  #   update(member_status: status)
  # end
end

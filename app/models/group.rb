class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true

  # enum member_status: { '承認待ち': 0, 'メンバー': 1, 'リーダー': 2, 'シニア': 3 }
  # enum graduate_status: { '卒業しない': 0, '卒業依頼': 1, '卒業': 2 }
  enum member_status: { pre_member: 0, member: 1, leader: 2, senior: 3 }
  enum graduate_status: { no_graduate: 0, pre_graduate: 1, graduated: 2 }
  # enumの名前は英語ならメソッド化できる

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
      update(member_status: statuses[status.to_sym], graduate_status: graduated)
      # update(member_status: statuses[status.to_sym], graduate_status: '卒業')
    elsif status.to_sym == :waiting_accept
      update(member_status: statuses[status.to_sym])
    elsif status.to_sym == :accept
      update(member_status: statuses[status.to_sym])
    elsif status.to_sym == :leader
      update(member_status: statuses[status.to_sym])
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

  def self.update_member_status!(activity_id, leader_ids)
    transaction do
      groups = where(activity_id: activity_id)
      pre_member_ids = groups.where(member_status: pre_member).pluck(:user_id)
      senior_ids = groups.where(member_status: senior).pluck(:user_id)
      groups.each {|group| group.member!}
      # @group.update(member_status: "メンバー")
      pre_groups = groups.where(user_id: pre_member_ids)
      pre_groups.each {|pre_group| pre_group.pre_member!}
      # @pre_group.update(member_status: "承認待ち")
      leader_groups = groups.where(user_id: leader_ids)
      leader_groups.each {|leader_group| leader_group.leader!}
      # @leader_group.update(member_status: "リーダー")
      senior_groups = groups.where(user_id: senior_ids)
      senior_groups.each {|senior_group| senior_group.senior!}
      # @senior_group.update(member_status: "シニア")
    end
  end

end

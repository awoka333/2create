class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true

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
      update(member_status: statuses[status.to_sym], graduate_status: :graduated)
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

  def self.update_member_status!(activity_id, leader_ids)                      # leaderのuser_idすべてを予め取得
    transaction do
      groups = where(activity_id: activity_id)
      pre_member_ids = groups.where(member_status: pre_member).pluck(:user_id) # pre_memberのuser_idすべてを予め取得
      senior_ids = groups.where(member_status: senior).pluck(:user_id)         # seniorのuser_idすべてを予め取得
      groups.each {|group| group.member!}                       # groupsのmember_statusをすべてmemberに上書きする。失敗に備えてトランザクション処理。
      pre_groups = groups.where(user_id: pre_member_ids)
      pre_groups.each {|pre_group| pre_group.pre_member!}       # pre_groupsのmember_statusをすべてpre_memberに上書きする。pre_member!はenumのカラム上書きメソッド。
      leader_groups = groups.where(user_id: leader_ids)
      leader_groups.each {|leader_group| leader_group.leader!}
      senior_groups = groups.where(user_id: senior_ids)
      senior_groups.each {|senior_group| senior_group.senior!}
    end
  end

end

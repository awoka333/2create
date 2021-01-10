class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true

  enum member_status: { '承認待ち': 0, 'メンバー': 1, 'リーダー': 2, 'シニア': 3 }
  enum graduate_status: { '卒業しない': 0, '卒業依頼': 1, '卒業': 2 }

  # returnは書いても書かなくてもよい
  # 10行目でgroup_sortという変数を宣言、コントローラのreturn_statusメソッドから値を貰う
  def self.return_status(group_sort)
    # if group_sort == '0'      # 使わない
    #   return '承認待ち'
    if group_sort == '1'      # サークル編集ページ(activities/edit)から来る
      return 'メンバー'
    # elsif group_sort == '2' # サークル編集ページ(activities/edit)のcheck_boxの値から、トランザクション処理する
    #   return 'リーダー'
    # elsif group_sort == '3' # group_sort == 100の時、同時更新する（3つ下の行）
    #   return 'シニア'
    elsif group_sort == "98"  # サークル編集ページ(activities/edit)から来る
      return '卒業しない'
    elsif group_sort == "99"  # マイページ(users/show)から来る
      return '卒業依頼'
    elsif group_sort == '100' # サークル編集ページ(activities/edit)から来る
      return '卒業'
    end
  end
end

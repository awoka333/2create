class Group < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :user_id, presence: true
  validates :activity_id, presence: true

  enum member_status: { '承認待ち': 0, 'メンバー': 1, 'リーダー': 2, 'シニア': 3 }
  enum graduate_status: { '卒業しない': 0, '卒業依頼': 1, '卒業': 2 }

  # returnは書いても書かなくてもよい
  # 10行目でorder_sortという変数を宣言、コントローラのreturn_statusメソッドから値を貰う
  def self.return_status(order_sort)
    if order_sort == '1'
      return 'メンバー'
    elsif order_sort == '2'
      return 'リーダー'
    elsif order_sort == '3'
      return 'シニア'
    elsif order_sort == "98"
      return '卒業しない'
    elsif order_sort == "99"
      return '卒業依頼'
    elsif order_sort == '100'
      return '卒業'
    end
  end
end

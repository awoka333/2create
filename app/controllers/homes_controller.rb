class HomesController < ApplicationController
  def top
    @theme = Theme.last
    @lastworks = Work.order('created_at DESC').where(is_masking: false).limit(3)
    # 検索機能ransack用に準備
    @q = Activity.ransack(params[:q])             #Activityの検索
    @activities = @q.result(distinct: true)
    @w = Work.ransack(params[:w], search_key: :w) #Workの検索
    @works = @w.result(distinct: true).where(is_masking: false)
  end

  def about
    @firstworks = Work.where(is_masking: false).order('created_at').limit(2)
    @theme = Theme.last
  end
end

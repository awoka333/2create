class HomesController < ApplicationController
  def top
    @theme = Theme.order(updated_at: :desc).limit(1)
    if Work.includes(:activity).count > 2
      @lastworks = Work.order('created_at DESC').limit(3)
    elsif Work.includes(:activity).count > 1
      @lastworks = Work.order('created_at DESC').limit(2)
    elsif Work.includes(:activity).count == 1
      @lastworks = Work.includes(:activity)
    end
    # 検索機能ransack用に準備
    @q = Activity.ransack(params[:q])             #Activityの検索
    @activities = @q.result(distinct: true)
    @w = Work.ransack(params[:w], search_key: :w) #Workの検索
    @works = @w.result(distinct: true)
  end

  def about
    @firstworks = Work.order('created_at').limit(2)
  end
end

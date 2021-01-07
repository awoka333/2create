class HomesController < ApplicationController
  def top
    if Work.all.count > 2
      @lastworks = Work.order(created_at: :desc).limit(3)
    elsif Work.all.count > 1
      @lastworks = Work.order(created_at: desc).limit(2)
    elsif Work.all.count == 1
      @lastworks = Work.all
    end
    # 検索機能ransack用に準備
    @q = Activity.ransack(params[:q])
    @activities = @q.result(distinct: true) #Activityの検索
    @w = Work.ransack(params[:w])
    @works = @w.result(distinct: true)      #Workの検索
  end

  def about
    @firstworks = Work.order('created_at').limit(2)
  end
end

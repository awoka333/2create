class HomesController < ApplicationController
  def top
    if Work.includes(:activity).count > 2
      @lastworks = Work.order('created_at DESC').limit(3)
    elsif Work.includes(:activity).count > 1
      @lastworks = Work.order('created_at DESC').limit(2)
    elsif Work.includes(:activity).count == 1
      @lastworks = Work.includes(:activity)
    end
    # 検索機能ransack用に準備
    @q = Activity.ransack(params[:q])
    @activities = @q.result(distinct: true) #Activityの検索
    # @different_search = Work.ransack(params[:w], search_key: :w)
    @w = Work.ransack(params[:w], search_key: :w)
    @works = @w.result(distinct: true)      #Workの検索
  end

  def about
    @firstworks = Work.order('created_at').limit(2)
  end
end

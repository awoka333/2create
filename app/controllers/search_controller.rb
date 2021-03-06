class SearchController < ApplicationController
  def search_result
    @theme = Theme.last
    if params[:q].present?
      @q = Activity.includes([:groups]).ransack(search_activity_params)
      @activities = @q.result(distinct: true).page(params[:page]).per(25)
    else
      @w = Work.ransack(params[:w], search_key: :w)
      @works = @w.result(distinct: true).page(params[:page]).per(10)
    end
  end

  private

  def search_activity_params
    params.require(:q).permit(:name_cont)
  end

  def search_work_params
    params.require(:w).permit(:title_cont)
  end
end

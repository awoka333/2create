class SearchController < ApplicationController
  def activity_search
    @q = Activity.search(activity_search_params)
    @activities = @q.result(distinct: true)
  end

  def work_search
    @w = Student.search(work_search_params)
    @works = @w.result(distinct: true)
  end

  private
  def activity_search_params
    params.require(:q).permit(:name_cont)
  end
  def work_search_params
    params.require(:w).permit(:title_cont)
  end
end

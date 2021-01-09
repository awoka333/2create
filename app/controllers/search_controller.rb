class SearchController < ApplicationController
  def search_result
    @theme = Theme.find(1)
    if params[:q].present?
      @q = Activity.ransack(search_activity_params)
      @activities = @q.result(distinct: true)
      @activities_paginate = @activities.page(params[:page]).per(10)
    else
      @w = Work.ransack(params[:w], search_key: :w)
      # @w = Work.ransack(search_work_params)
      @works = @w.result(distinct: true)
      @works_paginate = @works.page(params[:page]).per(10)
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

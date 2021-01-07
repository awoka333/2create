class WorksController < ApplicationController
  #before_action :creator1_string, only: [:create, :update]
  #before_action :creator2_string, only: [:create, :update]

  def new
    @work = Work.new
    @activity = Activity.find(params[:activity_id])
    @groups = Group.where(activity_id: @activity.id)
    user_ids = @groups.map(&:user_id)
    @users = User.where(id: user_ids)
  end

  def create
    # p "create"
    # p params[:work][:creator1]
    @work = Work.new(work_params)
    @activity = Activity.find(params[:activity_id])
    @work.user_id = current_user.id
    @work.activity_id = @activity.id
    if @work.save
      redirect_to work_path(@work)
    else
      @groups = Group.where(activity_id: @activity.id)
      user_ids = @groups.map(&:user_id)
      @users = User.where(id: user_ids)
      # sourceでモデルの記述が成功した場合
      # @users = @activity.group_users
      render 'new'
    end
  end

  def index
    if params[:order_sort] == '2'    # トップページ(root)(検索)から来た場合
      @w = Activity.search(activity_search_params)
      @works = @w.result(distinct: true)
    elsif params[:order_sort] == '3' # マイページ(users/show)から来た場合
      @works = current_user.works
    elsif params[:order_sort] == '4' # サークル詳細ページ(activities/show)から来た場合
      @activity = Activity.find(params[:activity_id])
      @works = @activity.works
    else
      @works = Work.all
    end
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def show
    @work = Work.find(params[:id])
    @activity = @work.activity
  end

  def modify
    @activity = Activity.find(params[:id])
    @works = Work.where(activity_id: @activity.id)
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def edit
    @work = Work.find(params[:id])
    @activity = @work.activity
    @users = @activity.users
  end

  # def mask
  #   @work = Work.find(params[:id])
  #   # boolean型カラムis_maskingdのステータスをfalseからtrueに変更
  #   @work.is_masking = true
  #   @work.save
  # end

  # def share
  #   @work = Work.find(params[:id])
  #   # boolean型カラムis_maskingdのステータスをtrueからfalseに変更
  #   @work.is_masking = false
  #   @work.save
  # end

  def update
    @work = Work.find(params[:id])
    if params[:order_sort] == '0'    # 作品を非公開状態にする
      @work.is_masking = true
    elsif params[:order_sort] == '1' # 作品を公開状態にする
      @work.is_masking = false
    elsif params[:order_sort] == '2'
      @work.update
    else
      render 'edit'
    end
    redirect_to request.referer
  end

  def destroy
    @work = Work.find(params[:id])
    activity = @work.activity
    @work.destroy
    redirect_to activity_path(activity)
  end

  private
  def work_params
    params.require(:work).permit(:user_id, :act_id, :title, :point, :work_image, creator1:[], creator2:[])
  end

  def creators1_string
    params[:work][:creator1] = params[:work][:creator1].join(", ")  # DB保存の前に配列を展開する
  end
  def creators2_string
    params[:work][:creator2] = params[:work][:creator2].join(", ")  # DB保存の前に配列を展開する
  end
  # ransack用のストロングパラメータ
  def work_search_params
    params.require(:w).permit(:title_cont)
  end
end

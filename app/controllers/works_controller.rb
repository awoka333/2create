class WorksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :creator1_string, only: [:create, :update]  # 配列展開
  before_action :creator2_string, only: [:create, :update], if: proc { params[:work][:creator2].present? } # [:work][:creator2]が送られてきているか確認

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def new
    @work = Work.new
    @activity = Activity.find(params[:activity_id])
    @groups = Group.where(activity_id: @activity.id)
    user_ids = @groups.map(&:user_id)
    @users = User.where(id: user_ids)
  end

  def create
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
    @theme = Theme.last
    if params[:work_sort] == '1' # マイページ(users/show)から来た場合
      @works = current_user.works
    elsif params[:work_sort] == '2' # サークル詳細ページ(activities/show)から来た場合
      @activity = Activity.find(params[:activity_id])
      @works = @activity.works
    else
      @works = Work.includes(:activity)
    end
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def show
    @work = Work.find(params[:id])
    @activity = @work.activity
    # before_actionがある時
    @creator1 = User.where(id: @work.creator1.split(',')) # @work.creator1の中身を配列にして、展開した配列の値すべてをidとして取得する
    if @work.creator2.present?
      @creator2 = User.where(id: @work.creator2.split(',')) # 配列の形式は["1", "2"]なので、','で区切ると配列になる
      # @creator1 = User.where(id: @work.creator1)  # creator1: "[\"1\", \"2\"]"
      # @creator2 = User.where(id: @work.creator2)  # creator2: "[\"2\", \"3\"]"という値を["2", "3"]に出来るなら、こちらを使いたい(creator1/2_stringを参照しないで済む)
    else
      @creator2 = User.none
    end
  end

  def modify
    @activity = Activity.find(params[:id])
    @works = Work.where(activity_id: @activity.id)
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def edit
    @work = Work.find(params[:id])
    @activity = @work.activity
    @groups = @activity.groups
    user_ids = @groups.map(&:user_id)
    @users = User.where(id: user_ids)
    # sourceでモデルの記述が成功した場合
    # @users = @activities.group_users
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
      # @work.is_masking = true      #代入と更新を1行で行うなら、下行
      @work.update(is_masking: true)
      redirect_to request.referer
    elsif params[:order_sort] == '1' # 作品を公開状態にする
      # @work.is_masking = false     #代入と更新を1行で行うなら、下行
      @work.update(is_masking: false)
      redirect_to request.referer
    elsif params[:order_sort] == '2'
      @work.update(work_params)
      redirect_to work_path(@work)
    else
      render 'edit'
    end
  end

  def destroy
    @work = Work.find(params[:id])
    activity = @work.activity
    @work.destroy
    redirect_to activity_path(activity)
  end

  private
  def work_params
    params.require(:work).permit(:user_id, :act_id, :title, :point, :work_image, :creator1, :creator2)
    # params.require(:work).permit(:user_id, :act_id, :title, :point, :work_image, creator1:[], creator2:[]) # 配列で取得する時はこの表記
  end

  # 配列で取得したデータ展開用のストロングパラメータ
  def creator1_string
    params[:work][:creator1] = params[:work][:creator1].join(", ")  # DB保存の前に配列を展開する
  end
  def creator2_string
    params[:work][:creator2] = params[:work][:creator2].join(", ")  # DB保存の前に配列を展開する
  end
end

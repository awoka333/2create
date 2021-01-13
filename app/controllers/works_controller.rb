class WorksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :not_user, if: proc { current_user.is_deleted == true }, except: [:index, :show]
  before_action :not_admin, if: proc { user_signed_in? && current_user.authority != "管理者" }, only: [:modify, :mask]

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def not_admin
    redirect_to request.referer
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
    if params[:work][:creator1] != nil      # check_boxの値の設定
      if params[:work][:creator2] != nil    # creator1とcreator2のparamsが両方ある時
        @work.creator1 = params[:work][:creator1].map!(&:to_i).join(", ")
        @work.creator2 = params[:work][:creator2].map!(&:to_i).join(", ")
      else                                  # creator1のparamsのみある時
        @work.creator1 = params[:work][:creator1].map!(&:to_i).join(", ")
      end
      if @work.save
        redirect_to work_path(@work)
      else
        @groups = Group.where(activity_id: @activity.id)
        @users = @activity.group_users
        render 'new'
      end
    # creator1にチェックが無い時
    else
      @groups = Group.where(activity_id: @activity.id)
      @users = @activity.group_users
      flash.now[:alert] = '・2creatorにチェックを入れてください'
      render 'new'
    end
  end

  def index
    @theme = Theme.last
    if params[:work_sort] == '1' # マイページ(users/show)から来た場合
      @works = Work.where(user_id: current_user.id, is_masking: false).page(params[:page]).per(10)
    elsif params[:work_sort] == '2' # サークル詳細ページ(activities/show)から来た場合
      @activity = Activity.find(params[:activity_id])
      @works = @activity.works.where(is_masking: false).page(params[:page]).per(10)
    else
      @works = Work.includes(:activity).where(is_masking: false).page(params[:page]).per(10)
    end
  end

  def show
    @work = Work.find(params[:id])
    @activity = @work.activity
    @creator1 = User.where(id: @work.creator1.split(',')) # @work.creator1の中身を配列にして、展開した配列の値すべてをidとして取得する
    if @work.creator2.present?
      @creator2 = User.where(id: @work.creator2.split(',')) # 配列の形式は["1", "2"]なので、','で区切ると配列になる  イメージ例 [:user]["n", "n+1, "n+2",...]
      # @creator1 = User.where(id: @work.creator1)  # creator1: "[\"1\", \"2\"]"
      # @creator2 = User.where(id: @work.creator2)  # creator2: "[\"2\", \"3\"]"という値を正規化して["2", "3"]に出来るなら、インスタンス変換せずに配列のまま保存していてもこの記述でよい
    else
      @creator2 = User.none
    end
  end

  def modify
    @activity = Activity.find(params[:activity_id])
    @works = Work.where(activity_id: @activity.id).page(params[:page]).per(10) # is_masking(公開ステータス)に関わらず全て取得
  end

  def edit
    @work = Work.find(params[:id])
    @activity = @work.activity
    @groups = @activity.groups
    @users = @activity.group_users
  end

  def update
    @work = Work.find(params[:id])
    # creator1とcreator2(idの配列)が送られてきた時  ※文字列nameの配列だと取得失敗
    if params[:work][:creator1] != nil
      if params[:work][:creator2] != nil    # creator1とcreator2のparamsが両方ある時
        @work.creator1 = params[:work][:creator1].map!(&:to_i).join(", ")
        @work.creator2 = params[:work][:creator2].map!(&:to_i).join(", ")
      else                                  # creator1のparamsのみある時
        @work.creator1 = params[:work][:creator1].map!(&:to_i).join(", ")
        @work.creator2 = nil  # creator2の値を空にする
      end
      if @work.update(work_params)
        redirect_to work_path(@work)
      else
        @activity = @work.activity
        @groups = @activity.groups
        @users = @activity.group_users
        render 'edit'
      end
    # creator1にチェックが無い時
    else
      @activity = @work.activity
      @groups = @activity.groups
      @users = @activity.group_users
      flash.now[:alert] = '・2creatorにチェックを入れてください'
      render 'edit'
    end
  end

  def mask
    @work = Work.find(params[:work_id])
    if params[:work_sort] == '0'    # 作品を非公開状態にする（管理者,works/modifyから)
      @work.update(is_masking: true)
    elsif params[:work_sort] == '1' # 作品を公開状態にする（管理者,works/modifyから)
      @work.update(is_masking: false)
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
    params.require(:work).permit(:user_id, :act_id, :title, :point, :work_image, :creator1, :creator2)
    # params.require(:work).permit(:user_id, :act_id, :title, :point, :work_image, creator1:[], creator2:[]) # 配列で取得する時はこの表記
  end
end

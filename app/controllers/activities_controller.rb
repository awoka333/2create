class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:not_user, :not_admin, :index, :show]
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }, except: [:index, :show]
  before_action :not_admin, if: proc { user_signed_in? && current_user.authority != "管理者" }, only: [:modify, :destroy]

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def not_admin
    redirect_to request.referer
  end


  def new
    @activity = Activity.new
  end

  def index
    @theme = Theme.last
    @activities = Activity.all.page(params[:page]).per(25)
  end

  def show
    @activity = Activity.find(params[:id])
    @groups = Group.where(activity_id: @activity.id)
    # updateアクションでmember_status: "シニア"から変更したgroupを、graduate_status: "卒業" と member_status: "シニア"が両立しないものと定義して検出
    @pre_seniors = @groups.where(graduate_status: :graduated).where.not(member_status: :senior)
    # @pre_senior_groups = @groups.where(user_id: @pre_seniors.pluck(:user_id))
    # @pre_senior_groups.update(graduate_status: "卒業しない")
    @pre_seniors.each {|pre_senior| pre_senior.no_graduate!}
    # @pre_seniors.no_graduate!
    # ここまででpre_seniorsのgraduate_status修正完了
    @seniors = @groups.where(member_status: :senior)
    @leaders = @groups.where(member_status: :leader)
    @juniors = @groups.where(member_status: :member)
    @pre_members = @groups.where(member_status: :pre_member)
    @pre_graduates = @groups.where(graduate_status: :pre_graduate)
    @comments = @activity.comments.order(created_at: :desc).limit(3) # 最大3つのレコードを配列として取得
    # ログイン時は、Recommendテーブルに同じものがある または Groupテーブルに同じものがある という場合を除き、Recommendレコードを作る
    if user_signed_in?
      if Group.where(user_id: current_user.id, activity_id: @activity.id).empty? && Recommend.find_by(user_id: current_user.id, activity_id: @activity.id).present?
        @recommend = Recommend.find_by(user_id: current_user.id, activity_id: @activity.id) # サークル所属しておらず、おすすめサークルとして登録はある時
        @recommend.touch(:updated_at) # touchメソッドはupdated_atカラムのみ更新・保存をするメソッド
      elsif Group.where(user_id: current_user.id, activity_id: @activity.id).empty?
        @recommend = Recommend.new(user_id: current_user.id, activity_id: @activity.id)   # サークル所属しておらず、おすすめサークルとして登録もない時
        @recommend.save
      end
    end
  end

  def modify
    @activities = Activity.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      leader = Group.new(
        user_id: current_user.id,
        activity_id: @activity.id,
        member_status: 'leader'
      )
      leader.save

      redirect_to activity_path(@activity.id)
    else
      render "new"
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    @groups = Group.where(activity_id: @activity.id)
    @pre_members = @groups.where(member_status: :pre_member)
    @leaders = @groups.where(member_status: :leader)
    @pre_graduates = @groups.where(graduate_status: :pre_graduate)
    # @leaders = @groups.where(member_status: 'リーダー')
    # @pre_graduates = @groups.where(graduate_status: '卒業依頼')
    @users = @activity.group_users
  end

  def update
    @activity = Activity.find(params[:id])
    @groups = Group.where(activity_id: @activity.id)
    @pre_members = @groups.where(member_status: :pre_member)
    @leaders = @groups.where(member_status: :leader)
    @pre_graduates = @groups.where(graduate_status: :pre_graduate)
    # pre_member_ids = @groups.where(member_status: :pre_member).pluck(:user_id)
    # senior_ids = @groups.where(member_status: :senior).pluck(:user_id)
    # pre_member_ids = @groups.where(member_status: '承認待ち').pluck(:user_id)
    # senior_ids = @groups.where(member_status: 'シニア').pluck(:user_id)
    if @activity.update(activity_params)
      # transaction処理で、値を一気に書き換えていく。eにはエラー内容が入る。
      # 一度全てメンバーに書き換えた後、@leadersで受け取ったuserをリーダーとして登録する。

      # メソッド化
      # @group.update_status_with_activity(params[:group_sort.to_sym])

      begin
        Group.update_member_status!(@activity.id, params[:activity][:leader])
        # Group.transaction do
        #   @group = Group.where(activity_id: @activity.id)
        #   @group.member!
        #   # @group.update(member_status: "メンバー")
        #   @pre_group = @group.where(user_id: pre_member_ids)
        #   @pre_group.pre_member!
        #   # @pre_group.update(member_status: "承認待ち")
        #   @leader_group = @group.where(user_id: @leaders)
        #   @leader_group.leader!
        #   # @leader_group.update(member_status: "リーダー")
        #   @senior_group = @group.where(user_id: senior_ids)
        #   @senior_group.senior!
        #   # @senior_group.update(member_status: "シニア")
        # end
        redirect_to activity_path(@activity)
      rescue => e
        @users = @activity.group_users
        render 'edit'
      end

    else
      @users = @activity.group_users
      render 'edit'
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    redirect_to activities_modify_path
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :act_image, :to_create, :to_study, :to_do)
  end
end

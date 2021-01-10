class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def new
    @activity = Activity.new
  end

  def index
    @theme = Theme.last
    @activities = Activity.all
    @activities_paginate = @activities.page(params[:page]).per(10)
  end

  def show
    @activity = Activity.find(params[:id])
    @works = Work.find(activity_id: @activity.id).order(created_at: :desc).limit(2) # 最大2つのレコードを配列として取得
    @groups = Group.where(activity_id: @activity.id)
    @seniors = @groups.where(member_status: 'シニア')
    @leaders = @groups.where(member_status: 'リーダー')
    @juniors = @groups.where(member_status: 'メンバー')
    @pre_members = @groups.where(member_status: '承認待ち')
    @pre_graduates = @groups.where(graduate_status: '卒業依頼')
    @comments = @activity.comments.order(created_at: :desc).limit(3) # 最大3つのレコードを配列として取得
    # ログイン時は、Recommendテーブルに同じものがある または Groupテーブルに同じものがある という場合を除き、Recommendレコードを作る
    if user_signed_in?
      if Recommend.where(user_id: current_user.id, activity_id: @activity.id).empty? || Group.where(user_id: current_user.id, activity_id: @activity.id).empty?
        @recommend = Recommend.new(user_id: current_user.id, activity_id: @activity.id)
        @recommend.save
      elsif Recommend.where(user_id: current_user.id, activity_id: @activity.id).exists? && Group.where(user_id: current_user.id, activity_id: @activity.id).empty?
        @recommend = Recommend.where(user_id: current_user.id, activity_id: @activity.id)
        @recommend.update
      end
    end
  end

  def modify
    @activities = Activity.all
    @activities_paginate = @activities.page(params[:page]).per(10)
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      leader = Group.new(
        user_id: current_user.id,
        activity_id: @activity.id,
        member_status: 'リーダー'
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
    @pre_members = @groups.where(member_status: '承認待ち')
    @leaders = @groups.where(member_status: 'リーダー')
    @pre_graduates = @groups.where(graduate_status: '卒業依頼')
    user_ids = @groups.map(&:user_id)
    @users = User.where(id: user_ids)
  end

  def update
    @activity = Activity.find(params[:id])
    @leaders = params[:activity][:leader]
    if @activity.update(activity_params)
      # transaction処理で、値を一気に書き換えていく。eにはエラー内容が入る。
      # 一度全てメンバーに書き換えた後、@leadersで受け取ったuserをリーダーとして登録する。
      begin
        Group.transaction do
          @group = Group.where(activity_id: @activity.id)
          @group.update(member_status: "メンバー")
          @group = @group.where(user_id: @leaders)
          @group.update(member_status: "リーダー")
        end
        redirect_to activity_path(@activity)
      rescue => e
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @group = Group.find(activity_id: @activity.id)
    @group.destroy
    redirect_to activities_modify_path
  end

  private
  def activity_params
    params.require(:activity).permit(:name, :act_image, :to_create, :to_study, :to_do)
  end
end

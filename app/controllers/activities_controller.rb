class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def index
    # if params[:q][:order_sort] == '1'    # トップページ(root)(検索)から来た場合
    #   @q = Activity.search(activity_search_params)
    #   @activities = @q.result(distinct: true)
    # else
      @activities = Activity.all
    # end
    @activities_paginate = @activities.page(params[:page]).per(10)
  end

  def show
    @activity = Activity.find(params[:id])
    if Work.where(activity_id: @activity_id).count > 1
      @works = Work.find(activity_id: @activity.id).order(created_at: :desc).limit(2)
    elsif Work.where(activity_id: @activity_id).count == 1
      @works = Work.find_by(activity_id: @activity.id)
    else
      @works = Work.none
    end
    @groups = Group.where(activity_id: @activity.id)
    @seniors = @groups.where(member_status: 'シニア')
    @leaders = @groups.where(member_status: 'リーダー')
    @juniors = @groups.where(member_status: 'メンバー')
    @pre_members = @groups.where(member_status: '承認待ち')
    if Comment.where(activity_id: @activity_id).count > 2
      @comments = @activity.comments.order(created_at: :desc).limit(3)
    elsif Comment.where(activity_id: @activity_id).count > 1
      @comments = @activity.comments.order(created_at: :desc).limit(2)
    elsif Comment.where(activity_id: @activity_id).count == 1
      @comments = @activity.comments
    else
      @comments = Comment.none
    end
    # ログイン時は、Recommendテーブルに同じものがある または Groupテーブルに同じものがある という場合を除き、Recommendレコードを作る
    if user_signed_in?
      unless Recommend.where(user_id: current_user.id, activity_id: @activity.id).exists? || Group.where(user_id: current_user.id, activity_id: @activity.id).exists?
        @recommend = Recommend.new(user_id: current_user.id, activity_id: @activity.id)
        @recommend.save
      end
    end
  end

  def modify
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
      render "edit"
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
  # ransack用のストロングパラメータ
  def activity_search_params
    params.require(:q).permit(:name_cont, :order_sort)
  end
end

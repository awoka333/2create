class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def index
    @activities = Activity.all
    @activities_paginate = Activity.page(params[:page]).per(10)
  end

  def show
    @activity = Activity.find(params[:id])
    if Work.where(act_id: @activity_id).count > 1
      @works = Work.find(act_id: @activity.id).order(created_at: :desc).limit(2)
    elsif Work.where(act_id: @activity_id).count == 1
      @works = Work.find_by(act_id: @activity.id)
    else
      @works = Work.none
    end
    @groups = Group.where(act_id: @activity.id)
    @seniors = @groups.where(member_status: 'シニア')
    leaders = @groups.where(member_status: 'リーダー')
    juniors = @groups.where(member_status: 'メンバー')
    @pre_members = @groups.where(member_status: '承認待ち')
    if Comment.where(act_id: @activity_id).exists?
      @comments = @activity.comments.order(created_at: :desc)
    else
      @comments = Comment.none
    end
  end

  def modify
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      leader = Group.new(group_params)
      leader.user_id = current_user.id
      leader.act_id = @activity.id
      leader.save
      redirect_to activity_path(@activity.id)
    else
      render "edit"
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    if Group.where(act_id: @activity.id).count > 0
      @users = User.where(act_id: @activity.id)
    else
      @users = User.none
    end
  end

  def update
    @activity = Activity.find(params[:id])
    @group = Group.find(act_id: @activity.id)
    @group.member_status = 'メンバー'
  end

  def destroy
    @activity = Activity.find(params[:id])
    @group = Group.find(act_id: @activity.id)
    @group.destroy
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :to_create, :to_study, :to_do)
  end

  def group_params
    params.require(:group).permit(:user_id, :act_id)
  end
end

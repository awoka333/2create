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
    if Work.where(activity_id: @activity_id).count > 1
      @works = Work.find(activity_id: @activity.id).order(created_at: :desc).limit(2)
    elsif Work.where(activity_id: @activity_id).count == 1
      @works = Work.find_by(activity_id: @activity.id)
    else
      @works = Work.none
    end
    @groups = Group.where(activity_id: @activity.id)
    @seniors = @groups.where(member_status: 'シニア')
    leaders = @groups.where(member_status: 'リーダー')
    juniors = @groups.where(member_status: 'メンバー')
    @pre_members = @groups.where(member_status: '承認待ち')
    if Comment.where(activity_id: @activity_id).exists?
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
    @group = Group.where(activity_id: @activity.id)
    if @groups.count > 0
      @users = @group.users
    else
      @users = User.none
    end
  end

  def update
    @activity = Activity.find(params[:id])
    @group = Group.find(activity_id: @activity.id)
    @group.member_status = 'メンバー'
  end

  def destroy
    @activity = Activity.find(params[:id])
    @group = Group.find(activity_id: @activity.id)
    @group.destroy
    redirect_to ctivities_modify
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :act_image, :to_create, :to_study, :to_do)
  end

end

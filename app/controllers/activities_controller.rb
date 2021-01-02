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
    @works = Work.find(activity_id: @activity.id).order(created_at: :desc).limit(2)
    @groups = Group.where(activity_id: @activity.id)
    seniors = @groups.where(member_status: 'シニア')
    leaders = @groups.where(member_status: 'リーダー')
    juniors = @groups.where(member_status: 'メンバー')
    pre_members = @groups.where(member_status: '承認待ち')
    @comments = @activity.comments.order(created_at: :desc)
  end

  def modify
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to activity_path(@activity.id)
    else
      render "edit"
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    @users = User.where(activity_id: @activity.id)
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
  end

  private
  def activity_params
    params.require(:activity).permit(:name, :to_create, :to_study, :to_do)
  end
end

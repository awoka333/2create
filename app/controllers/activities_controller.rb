class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def index
    @activities_paginate = Activity.page(params[:page]).per(10)
  end

  def show
  end

  def public
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

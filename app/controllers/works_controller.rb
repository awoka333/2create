class WorksController < ApplicationController
   before_action :creator1_string, only: [:create, :update]
   before_action :creator2_string, only: [:create, :update]

  def new
    @work = Work.new
    @activity = Activity.find(params[:id])
  end

  def create
    @work = Work.new(work_params)
    @activity = Activity.find(params[:id])
    @work.act_id = @activity.id
  end

  def index
    @works = Work.all
    @works_paginate = Work.page(params[:page]).per(10)
  end

  def show
    @work = Work.find(params[:id])
    @activity = @work.activity
  end

  def modify
    @activity = Activity.find(params[:id])
    @works = Work.where(act_id: @activity.id)
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def edit
    @work = Work.find(params[:id])
    @activity = @work.activity
    @users = @activity.users
  end

  def mask
    @work = Work.find(params[:id])
    # boolean型カラムis_maskingdのステータスをfalseからtrueに変更
    @work.is_masking = true
    @work.save
  end

  def share
    @work = Work.find(params[:id])
    # boolean型カラムis_maskingdのステータスをtrueからfalseに変更
    @work.is_masking = false
    @work.save
  end

  private
  def work_params
    params.require(:work).permit(:user_id, :act_id, :title, :point, :creator1, :creator2, :work_image_id)
  end

  def creators1_string
    params[:work][:creator1] = params[:work][:creator1].join(", ")  # DB保存の前に配列を展開する
  end
  def creators2_string
    params[:work][:creator2] = params[:work][:creator2].join(", ")  # DB保存の前に配列を展開する
  end
end

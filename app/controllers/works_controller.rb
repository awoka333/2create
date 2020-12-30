class WorksController < ApplicationController
  def new
  end

  def index
  end

  def show
  end

  def modify
    @activity = Activity.find(params[:id])
    @works = Work.where(activity_id: @activity.id)
    @works_paginate = @works.page(params[:page]).per(10)
  end

  def edit
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
end

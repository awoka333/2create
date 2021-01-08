class CommentsController < ApplicationController
  def index
    @activity = Activity.find(params[:activity_id])
    @comments = Comment.where(activity_id: @activity.id)
    @comment = Comment.new
    @comments_paginate = Comment.page(params[:page]).per(3)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def modify
    @activity = Activity.find(params[:id])
    @comments = Comment.where(activity_id: @activity.id)
    @comment = Comment.new
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.activity_id = @activity.id
    @comment.save
    redirect_to request.referer
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to comments_path(activity_id: @comment.activity_id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :activity_id, :sentence)
  end
end

class CommentsController < ApplicationController
  def index
    @activity = Activity.find(params[:id])
    @comments = Comment.where(act_id: @activity.id)
    @comment = Comment.new
    @comments_paginate = Comment.page(params[:page]).per(3)
  end

  def modify
    @activity = Activity.find(params[:id])
    @comments = Comment.where(act_id: @activity.id)
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    redirect_to request.referer
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.save
    redirect_to request.referer
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :act_id, :sentence)
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }
  before_action :modify, if: proc { user_signed_in? && current_user.authority == "管理者" }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def index
    @activity = Activity.find(params[:activity_id])
    @comments = Comment.where(activity_id: @activity.id).order(created_at: :desc).page(params[:page]).per(25)
    @comment = Comment.new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def modify
    # 自然言語処理機能 導入予定
    @activity = Activity.find(params[:activity_id])
    @comments = Comment.where(activity_id: @activity.id).order(created_at: :desc).page(params[:page]).per(25)
    @comment = Comment.new
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.activity_id = @activity.id
    @comment.save
    render 'index'
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    redirect_to comments_path(activity_id: @comment.activity_id)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render 'index'
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :activity_id, :sentence)
  end
end

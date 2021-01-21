class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }
  before_action :modify, if: proc { user_signed_in? && current_user.authority == "管理者" }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def index
    @activity = Activity.find(params[:activity_id])
    @comments = Comment.includes([:user]).where(activity_id: @activity.id).order(created_at: :desc).page(params[:page]).per(25)
    @comment = Comment.new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def modify
    @activity = Activity.find(params[:activity_id])
    @comments = Comment.includes([:user]).where(activity_id: @activity.id).order(created_at: :desc).page(params[:page]).per(25)
    @comment = Comment.new
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.activity_id = @activity.id
    @comment.score = Language.get_data(comment_params[:sentence]) # sentenceの自然言語処理をする
    if @comment.save
      redirect_to request.referer
    else
      @comments = Comment.includes([:user]).where(activity_id: @activity.id).order(created_at: :desc).page(params[:page]).per(25)
      render 'index'
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.score = Language.get_data(comment_params[:sentence]) # sentenceの自然言語処理をする
    if @comment.update(comment_params)
      redirect_to comments_path(activity_id: @comment.activity_id)
    else
      render 'edit'
    end
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

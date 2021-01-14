class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }
  before_action :not_admin, if: proc { user_signed_in? && current_user.authority != "管理者" }, only: [:show]

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def not_admin
    redirect_to request.referer
  end

  def show
    @user = User.find(params[:id])
    @groups = @user.groups.page(params[:page]).per(25)
  end

  def create
    @activity = Activity.find(params[:activity_id])
    @group = Group.new(user_id: current_user.id)
    @group.activity_id = @activity.id
    if @group.save
      @recommend = Recommend.find_by(user_id: current_user.id, activity_id: @activity.id)
      @recommend.destroy
      redirect_to activity_path(@activity)
    else
      render 'activities/show'
    end
  end

  def update
    @group = Group.find(params[:id])
    # update内容を分類する。groupモデルのupdate_statusメソッド参照。
    @group.update_status(params[:group_sort])
    if @group.save
      redirect_to request.referer
    else
      redirect_to 'users/show'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to request.referer
  end
end

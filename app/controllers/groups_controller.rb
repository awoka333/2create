class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def show
    @user = User.find(params[:id])
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
    # update内容を分類する。groupモデルのreturn_statusメソッド参照。
    if params[:group_sort].to_i < 50
      @group.member_status = Group.return_status(params[:group_sort])
    elsif params[:group_sort].to_i < 100
      @group.graduate_status = Group.return_status(params[:group_sort])
    elsif params[:group_sort].to_i == 100
      @group.member_status = 'シニア'
      @group.graduate_status = Group.return_status(params[:group_sort])
    else
      redirect_to 'users/show'
    end
    @group.save
    redirect_to request.referer
    # 1行で書く場合
    # if params[:order_sort] < 50
    #   @group.member_status = Group.member_statuses.find {|k, v| v == params[:order_sort].to_i}[0]
    # elsif params[:order_sort] > 50
    #   @group.graduate_status = Group.graduate_statuses.find {|k, v| v == params[:order_sort].to_i}[0]
    # else
    #   redirect_to 'users/show'
    # end

    # updateのブロックでの書き方
    # @group.update({

    # })
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to request.referer
  end
end

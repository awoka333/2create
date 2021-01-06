class GroupsController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    # update内容を分類する。groupモデルのreturn_statusメソッド参照。
    if params[:order_sort] < 50
      @group.graduate_status = Group.return_status(params[:order_sort])
    elsif params[:order_sort] > 50
      @group.graduate_status = Group.return_status(params[:order_sort])
    else
      redirect_to 'users/show'
    end
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
    redirect_to my_page_path
  end

  private
  def group_params
    params.require(:group).permit(:member_status, :graduate_status)
  end
end

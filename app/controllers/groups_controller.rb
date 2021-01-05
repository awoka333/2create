class GroupsController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    # update内容を分類する
    if params[:order_sort] == '1'
      @group.member_status = 'メンバー'
    elsif params[:order_sort] == '2'
      @group.member_status = 'リーダー'
    elsif params[:order_sort] == '3'
      @group.member_status = 'シニア'
    elsif params[:order_sort] == "98"
      @group.graduate_status = '卒業しない'
    elsif params[:order_sort] == "99"
      @group.graduate_status = '卒業依頼'
    elsif params[:order_sort] == '100'
      @grouup.graduate_status = '卒業'
    end

    if @group.update
      redirect_to my_page_path
    else
      render 'users/show'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to my_page_path
  end
end

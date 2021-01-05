class UsersController < ApplicationController
  def show
    if Recommend.where(user_id: current_user.id).count > 2
      @reccomends = Recommend.limit(3).where(user_id: current_user.id)
    elsif Recommend.where(user_id: current_user.id).count > 1
      @reccomends = Recommend.limit(2).where(user_id: current_user.id)
    elsif Recommend.where(user_id: current_user.id).count == 1
      @reccomends = Recommend.find_by(user_id: current_user.id)
    else
      @reccomends = Recommend.none
    end
    @groups = current_user.groups
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to my_page_path
    else
      render 'edit'
    end
  end

  def unsubscribe
  end

  def withdraw
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

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
    @activities = current_user.activities
  end

  def edit
    @user = current_user(id: current_user.id)
  end

  def update
  end

  def unsubscribe
  end

  def withdraw
  end
end

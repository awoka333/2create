class UsersController < ApplicationController
  def show
    @reccomends = Recommend.limit(3).where(user_id: current_user.id)
    @activities = current_user.activities
  end

  def edit
    @user = current_user(id: current_user.id)
  end

  def unsubscribe
  end
end

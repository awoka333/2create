class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    if Recommend.where(user_id: current_user.id).count > 2
      @recommends = Recommend.limit(3).where(user_id: current_user.id)
      activity_ids = @recommends.map(&:activity_id)   # 配列でactivity_idを全て取得
      @activities = Activity.where(id: activity_ids)  # idがactivity_idsと合致するActivityのレコードを全て取得
    elsif Recommend.where(user_id: current_user.id).count > 1
      @recommends = Recommend.limit(2).where(user_id: current_user.id)
      activity_ids = @recommends.map(&:activity_id)
      @activities = Activity.where(id: activity_ids)
    elsif Recommend.where(user_id: current_user.id).count == 1
      @recommends = Recommend.find_by(user_id: current_user.id)
      @activities = Activity.find(id: @recommends.activity_id)
    else
      @recommends = Recommend.none
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
    @user = current_user
  end

  def withdraw
    @user = current_customer
    # usersテーブルis_deletedのステータスを変更
    @user.is_deleted = true
    # ログアウトさせてrootに画面遷移
    sign_out
    # redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def index
    @users = User.all
  end

  def show
    @recommends = Recommend.order('created_at DESC').limit(3).where(user_id: current_user.id) # 最大3つのレコードを配列として取得
    activity_ids = @recommends.map(&:activity_id)   # 配列でactivity_idを全て取得
    @activities = Activity.where(id: activity_ids)  # idがactivity_idsと合致するActivityのレコードを全て取得
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
    sign_out
    # redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

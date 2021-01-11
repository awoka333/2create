class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }
  before_action :index, if: proc { user_signed_in? && current_user.authority == "管理者" }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def index  # 管理者専用画面
    @users = User.where("authority == 'ユーザー' or authority is null").order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @user = current_user
    @theme = Theme.last
    @recommends = Recommend.order('updated_at DESC').limit(3).where(user_id: current_user.id) # 最大3つのレコードを配列として取得
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
    @user = current_user
    # usersテーブルis_deletedのステータスを変更
    @user.is_deleted = true
    sign_out
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email)
  end
end

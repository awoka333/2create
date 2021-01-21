class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }
  before_action :not_admin, if: proc { user_signed_in? && current_user.authority != "管理者" }, only: [:index]

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def not_admin
    redirect_to request.referer
  end

  def index  # 管理者専用画面
    @users = User.where(authority: 'ユーザー').order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @user = current_user
    @theme = Theme.last
    @groups = current_user.groups.includes([:activity])
    @recommends = Recommend.where(user_id: current_user.id).includes([:activity]).order('updated_at DESC').limit(3) # 最大3つのレコードを配列として取得
    @activities = []                    # 空の配列@activitiesを用意
    @recommends.each do |recommend|     # @recommendsを展開し、紐づくActivityのレコードすべてを@activitiesに入れる
      @activities << recommend.activity
    end
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

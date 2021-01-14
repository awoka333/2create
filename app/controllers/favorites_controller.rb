class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def create
    @work = Work.find(params[:work_id])
    @favorite = current_user.favorites.new(work_id: @work.id)
    @favorite.save
  end

  def destroy
    @work = Work.find(params[:work_id])
    @favorite = current_user.favorites.find_by(work_id: @work.id)
    @favorite.destroy
  end
end

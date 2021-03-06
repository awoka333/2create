class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { user_signed_in? && current_user.is_deleted == true }
  before_action :not_admin, if: proc { user_signed_in? && current_user.authority != "管理者" }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def not_admin
    redirect_to request.referer
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      redirect_to my_page_path
    else
      render 'new'
    end
  end

  private

  def theme_params
    params.require(:theme).permit(:month, :theme1, :theme2, :theme3, :sentence)
  end
end

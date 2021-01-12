class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }
  before_action :new, :create, if: proc { user_signed_in? && current_user.authority == "管理者" }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def new
    @theme = Theme.new(theme_params)
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

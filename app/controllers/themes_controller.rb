class ThemesController < ApplicationController
  before_action :authenticate_user!
  before_action :not_user, if: proc { current_user.is_deleted == true }

  def not_user
    sign_out
    redirect_to new_user_registration_path
  end

  def edit
  end
end

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  authorize_resource
end

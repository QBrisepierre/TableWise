class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    dashboard_restaurant_path(current_user.restaurant.id)
  end
end

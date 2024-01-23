class NoShowsController < ApplicationController

  def create
    raise
    @no_show = NoShow.new(no_show_params)
    @no_show.save

    redirect_to dashboard_restaurant_path(current_user.restaurant_ids.first)
  end

  private

  def no_show_params
    params.require(:customer).permit(:customer_id, :restaurant_id, :date_service)
  end
end

class CustomersController < ApplicationController

  def create
    @customer = Customer.new(customer_params)
    @customer.save

    @restaurant = Restaurant.find_by(user_id: current_user.id)

    @no_show = NoShow.new(customer_id: @customer.id, restaurant_id: @restaurant.id, date_service: DateTime.now)
    @no_show.save

    redirect_to dashboard_restaurant_path(current_user.restaurant.id)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone, :email)
  end
end

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:dashboard]

  def dashboard
    if params[:query].present?
      no_shows = @restaurant.customers
      found_customer = Customer.search_by_email_and_phone(params[:query])
      @customers = found_customer.select do |element|
        no_shows.include?(element)
      end
    end
    @customer = Customer.new
  end

  def search
    if params[:query].present?
      @customers = Customer.search_by_email_and_phone(params[:query])
    end
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.save

    redirect_to restaurant_path(@restaurant)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :email)
  end
end

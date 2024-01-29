class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:dashboard]
  helper_method :find_customer, :find_noshows_by_restaurant

  def dashboard
    # If searching
    if params[:query].present?
      no_shows = @restaurant.customers
      found_customer = Customer.search_by_email_and_phone(params[:query])
      @customers = found_customer.select do |element|
        no_shows.include?(element)
      end
      @count = @customers.count + 1
    else
      # else return all no_shows unique
      @no_shows = @restaurant.no_shows.uniq{|n| n.customer_id}
      @count = @no_shows.count + 1
    end

    # Statistique
    @no_shows_this_month = @restaurant.no_shows.select { |no_show| (Date.today - no_show.date_service).to_i < 30 }
    @no_shows_last_month = @restaurant.no_shows.select { |no_show| (Date.today - no_show.date_service).to_i > 30 }

    uniq_customer = @restaurant.no_shows.uniq { |t| t.customer_id}
    all = []
    uniq_customer.each do |n|
      all << n.customer.no_shows.select { |n| n.restaurant_id != @restaurant.id }.count
    end
    sum = 0
    all.each {|a| sum += a}
    if sum > 0 || @restaurant.no_shows.count > 0
      @fiability = (sum.fdiv(@restaurant.no_shows.count) * 100).to_i
    else
      @fiability = 0
    end

    unless @restaurant.no_shows.empty?
      if @no_shows_this_month.count > @no_shows_last_month.count &&  @no_shows_last_month.count > 0
        @delta = ((@no_shows_this_month.count - @no_shows_last_month.count) * 100).fdiv(@no_shows_last_month.count).to_i

      elsif @no_shows_this_month.count < @no_shows_last_month.count
        @delta = ((@no_shows_this_month.count - @no_shows_last_month.count) * 100).fdiv(@no_shows_last_month.count).to_i

      else
        @delta = 0
      end
    end

    # Create new no_shows for opening modal
    @customer = Customer.new
  end

  def find_customer(customer)
    Customer.find(customer)
  end

  def find_noshows_by_restaurant(customer)
    no_shows_by_restaurant = customer.no_shows.select{ |n| n.restaurant_id == @restaurant.id}
    no_shows_by_restaurant.sort_by {|d| d.date_service}.reverse
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

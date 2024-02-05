class RestaurantsController < ApplicationController
  require 'csv'
  before_action :set_restaurant, only: [:dashboard]
  helper_method :find_customer, :find_noshows_by_restaurant, :no_shows_to_array

  def dashboard
    # Check if a search query is present in the params
    if params[:query].present?
      # If searching, retrieve customers with no-shows based on the query
      # Find all no_shows for one restaurant
      no_shows = @restaurant.customers
      # Searching in all bdd
      found_customer = Customer.search_by_email_and_phone(params[:query])
      # Select only customer's have no_show fo this restaurant
      @customers = found_customer.select do |customer|
        no_shows.include?(customer)
      end
      @count = @customers.count + 1
    else
       # If no search query, return all unique no-shows for the restaurant
      @customers = unique_no_shows
      @count = @customers.count + 1
    end

    # Calculate and set statistics for the dashboard
    calculate_statistics

     # Create a new customer instance for opening a modal
    @customer = Customer.new
  end

  # Helper methods

  # Find and return a customer by their ID
  def find_customer(customer)
    Customer.find(customer)
  end

  # Find and return no-shows for a specific customer in the current restaurant
  def find_noshows_by_restaurant(customer)
    no_shows_by_restaurant = customer.no_shows.select{ |n| n.restaurant_id == @restaurant.id}
    no_shows_by_restaurant.sort_by {|d| d.date_service}.reverse
  end

  # Search for customers based on a query, if present
  def search
    @customers = search_customers(params[:query]) if params[:query].present?
    @count = @customers.count + 1 if @customers.present?
    if params[:import_phone]
      @import_phone = params[:import_phone]
      @phone = {}
      @import_phone.each do |phone|
        @phone[phone[2..-1].split("").unshift("0").join] = false
      end
      @phone.each do |phone, value|
        @phone[phone] = true if Customer.search_by_email_and_phone(phone).present?
      end
      raise

    end
  end

  def import
    file = params[:file]
    csv = File.open(file)
    @import_phone = []
    CSV.foreach(csv, headers: :first_row) do |row|
      @import_phone << row["Tel."] if row["Tel."].present?
    end
    redirect_to search_restaurant_path(current_user.restaurant.id, params: {import_phone: @import_phone})
  end

  # Initialize a new restaurant instance for creating a new restaurant
  def new
    @restaurant = Restaurant.new
  end

  # Create a new restaurant based on the parameters and redirect to its path
  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.save

    redirect_to restaurant_path(@restaurant)
  end

  def no_shows_to_array(customer)
    c = []
    c = customer.no_shows.each {|n| c << n}
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone, :email)
  end

  # Helper methods

  def search_customers(query)
    Customer.search_by_email_and_phone(query)
  end

  # Get unique no-shows associated with the current restaurant
  def unique_no_shows
     # Retrieve customers with at least one no_show for this restaurant
    customers_with_no_shows = Customer.joins(:no_shows)
                                       .where('no_shows.restaurant_id' => @restaurant.id)
                                       .distinct
                                       .order('customers.created_at ASC')

    # Sort customers by the date of their latest no_show in descending order
    @customers_with_no_shows = customers_with_no_shows.sort_by do |customer|
      customer.no_shows.maximum(:date_service)
    end.reverse
  end

  def calculate_statistics
    # Calculate the no-shows for the current month and the previous month
    @no_shows_this_month = recent_no_shows(Date.today.beginning_of_month, Date.today.end_of_month)
    @no_shows_last_month = recent_no_shows(Date.today.prev_month.beginning_of_month, Date.today.prev_month.end_of_month)

    # Get unique customers who have made no-shows
    uniq_customer = unique_no_show_customers

    # Calculate the total number of no-shows for other restaurants for each unique customer
    all = calculate_no_shows_for_other_restaurants(uniq_customer)

    # Calculate the reliability of no-shows for the current restaurant
    calculate_fiability(all)

    # Calculate the variation (delta) between the current month's no-shows and the previous month's
    calculate_delta
  end

  # ...

  # Helper methods

  def recent_no_shows(start_date, end_date)
    date_range = start_date..end_date
    @restaurant.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }
  end

  def unique_no_show_customers
    # Retrieve unique customers who have made no-shows
    @restaurant.no_shows.uniq { |t| t.customer_id }
  end

  def calculate_no_shows_for_other_restaurants(uniq_customer)
    # Calculate the total number of no-shows for other restaurants for each unique customer
    all = uniq_customer.map do |n|
      n.customer.no_shows.select { |n| n.restaurant_id != @restaurant.id }.count
    end
    all
  end

  def calculate_fiability(all)
    sum = all.sum
    # Calculate the reliability percentage for the current restaurant
    @fiability = (sum.fdiv(@restaurant.no_shows.count) * 100).to_i if sum > 0 || @restaurant.no_shows.count > 0
    @fiability ||= 0
  end

  def calculate_delta
    unless @restaurant.no_shows.empty?
      if @no_shows_this_month.count > @no_shows_last_month.count &&  @no_shows_last_month.count > 0
        # Calculate the percentage change (delta) between the current month's no-shows and the previous month's
        @delta = ((@no_shows_this_month.count - @no_shows_last_month.count) * 100).fdiv(@no_shows_last_month.count).to_i
      elsif @no_shows_this_month.count < @no_shows_last_month.count
        @delta = ((@no_shows_this_month.count - @no_shows_last_month.count) * 100).fdiv(@no_shows_last_month.count).to_i
      else
        @delta = 0
      end
    end
  end
end
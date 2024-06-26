class RestaurantsController < ApplicationController
  require 'csv'
  before_action :set_restaurant, only: [:dashboard]
  helper_method :find_customer, :find_noshows_by_restaurant, :no_shows_to_array, :fiability_customer

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
    else
      # If no search query, return all unique no-shows for the restaurant
      @customers = unique_no_shows
    end
    @count = @customers.count + 1

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

  def fiability_customer(customer)
    # start_date = Date.today - 90
    # start_date = start_date.beginning_of_month
    # end_date =  Date.today.end_of_month
    # date_range = start_date..end_date
    # last_four_month = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }
    # if customer.no_shows.count < 10
    #   first_coef = "1.0".split.push(customer.no_shows.count).join.to_f
    # else
    #   first_coef = "1.".split.push(customer.no_shows.count).join.to_f
    # end
    # if last_four_month.count < 10
    #   second_coef = "1.0".split.push(last_four_month.count).join.to_f
    # else
    #   second_coef = "1.".split.push(last_four_month.count).join.to_f
    # end
    # return ((customer.no_shows.count * last_four_month.count) * first_coef * second_coef / 100).round(2)
    date_last_one_week = Date.today - 7
    date_range = date_last_one_week.beginning_of_week..Date.today
    no_show_last_one_week = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }.count

    date_last_two_week = Date.today - 14
    date_range = date_last_two_week.beginning_of_week..date_last_two_week.end_of_week
    no_show_last_two_week = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }.count

    date_last_three_week = Date.today - 21
    date_range = date_last_three_week.beginning_of_week..date_last_three_week.end_of_week
    no_show_last_three_week = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }.count

    date_last_four_week = Date.today - 28
    date_range = date_last_four_week.beginning_of_week..date_last_four_week.end_of_week
    no_show_last_four_week = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }.count

    start_date_last_four_month = Date.today - 120
    end_date_last_four_month = Date.today - 30
    date_range = start_date_last_four_month.beginning_of_month..end_date_last_four_month.end_of_month
    no_show_last_four_month = customer.no_shows.select { |no_show| date_range.cover?(no_show.date_service) }.count

    if customer.no_shows.count < 10
      first_coef = "1.0".split.push(customer.no_shows.count).join.to_f
    else
      first_coef = "1.".split.push(customer.no_shows.count).join.to_f
    end
    score = (customer.no_shows.count * first_coef) + (no_show_last_one_week * 70) + (no_show_last_two_week * 50) + (no_show_last_three_week * 30) + (no_show_last_four_week * 15) + (no_show_last_four_month * 5)
    if score.to_i < 50
      return "Faible"
    elsif score.to_i > 50 && score.to_i < 80
      return "Risque élévé"
    else
      return "Risque très élévé"
    end
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
        if phone[0] != "0"
          phone = phone[2..-1].split("").unshift("0").join
        end
        @phone[phone] = Customer.search_by_email_and_phone(phone) if Customer.search_by_email_and_phone(phone).present?
      end
      @count = @phone.count + 1
      if @count == 1
        flash[:alert] = "Aucun noshow trouvé"
      else
        if @count < 3
          flash[:notice] =  "#{@count - 1} noshow trouvé"
        else
          flash[:notice] =  "#{@count - 1} noshow trouvés"
        end
      end
    end
    if params[:query].present?
      # If searching, retrieve customers with no-shows based on the query
      # Find all no_shows for one restaurant
      # Searching in all bdd
      @customers = Customer.search_by_email_and_phone(params[:query])
      # Select only customer's have no_show fo this restaurant
      @count = @customers.count + 1
      if @count == 1
        flash[:alert] = "Aucun noshow trouvé"
      else
        if @count < 3
          flash[:notice] =  "#{@count - 1} noshow trouvé"
        else
          flash[:notice] =  "#{@count - 1} noshow trouvés"
        end
      end
    end
  end

  def import
    file = params[:file]
    csv = File.open(file, "r:ISO-8859-1")
    @import_phone = []
    CSV.foreach(csv, headers: :first_row) do |row|
      @import_phone << row["Tel."] if row["Tel."].present?
    end
    redirect_to search_restaurant_path(current_user.restaurant.id, params: {import_phone: @import_phone})
  end

  def import_list
    if params[:phone].present?
      import_phone = params[:phone].split
      redirect_to search_restaurant_path(current_user.restaurant.id, params: {import_phone: import_phone})
    elsif params[:file].present?
      file = params[:file]
      csv = File.open(file, "r:ISO-8859-1")
      import_phone = []
      CSV.foreach(csv, headers: :first_row) do |row|
        import_phone << row["Tel."] if row["Tel."].present?
      end
      redirect_to search_restaurant_path(current_user.restaurant.id, params: {import_phone: import_phone})
    end
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
    else
      @delta = 0
    end
  end
end

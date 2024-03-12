class CustomersController < ApplicationController
  def create
    # Create a new customer instance with the provided parameters
    @customer = Customer.new(customer_params)

    # Check if the customer is valid
    if @customer.valid?
      # Save the customer if valid
      @customer.save
    else
      # If not valid, handle the error and attempt to find an existing customer by phone
      search = @customer.errors.messages.first[0].to_s
      phone = params[:customer][:phone]
      @customer = Customer.find_by(phone: phone) if search == 'phone'
    end

    # Find the restaurant associated with the current user
    @restaurant = Restaurant.find_by(user_id: current_user.id)

    # Parse the date parameter
    @date = Date.parse(params[:date])

    # Create a new NoShow instance for the customer's no-show record
    @no_show = NoShow.new(customer_id: @customer.id, restaurant_id: @restaurant.id, date_service: @date)
    @no_show.save

    # Redirect to the restaurant dashboard after the customer and no-show records are created
    redirect_to dashboard_restaurant_path(current_user.restaurant.id), notice: 'NoShow ajouté'
  end

  private

  # Define strong parameters for customer creation
  def customer_params
    params.require(:customer).permit(:name, :phone, :email)
  end
end
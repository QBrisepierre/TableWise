class CustomersController < ApplicationController

  def create
    @customer = Customer.new(customer_params)
    
    phone = customer_params["phone"].gsub(/(?<=\d{2})(\d{2})/, ' \1')
    @customer.phone = phone
    if @customer.valid?
      @customer.save
    else
      search = @customer.errors.messages.first[0].to_s
      @customer = Customer.find_by(phone: phone) if search == 'phone'
    end
    @restaurant = Restaurant.find_by(user_id: current_user.id)

    @date = Date.parse(params[:date])

    @no_show = NoShow.new(customer_id: @customer.id, restaurant_id: @restaurant.id, date_service: @date)
    @no_show.save

    redirect_to dashboard_restaurant_path(current_user.restaurant.id)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone, :email)
  end
end

require 'faker'
Faker::Config.locale = 'fr'

if Rails.env.development?
  puts "Deleting all customers"
  Customer.destroy_all
  
  puts "Deleting all Restaurants"
  Restaurant.destroy_all
  
  puts "Deleting all Users"
  User.destroy_all
  
  puts "Creating 2 new user..."
  user = User.new(email: "restaurant@gmail.com", password: "123456")
  if user.valid?
    user.save
    puts "User was created successfully : #{user}"
  end
  
  user2 = User.new(email: "restaurant2@gmail.com", password: "123456")
  if user2.valid?
    user2.save
    puts "User was created successfully : #{user2}"
  end
  
  puts "Creating 2 new restaurants for 2 users"
  [user, user2].each do |user|
    puts "Creating new restaurant for #{user.email}"
    restaurant = Restaurant.new(
      name: Faker::Restaurant.name,
      address: Faker::Address.full_address,
      phone: Faker::PhoneNumber.cell_phone,
      email: Faker::Internet.email,
      user_id: user.id
    )
    if restaurant.valid?
      restaurant.save
      puts "Restaurant was created successfully #{restaurant}"
    end
  end
  
  system("clear")
  
  puts "Creating 100 new customers with random noshows between 1 to 10"
  100.times do 
    puts "Creating new customer"
    regex = /^((0)[1-9]([0-9][0-9]){4})$/
    phone = ""
    result = false
    while result == false
      phone = Faker::PhoneNumber.cell_phone
      result = true if phone.match(regex)
    end
    if phone.match(regex)
      customer = Customer.new(
        name: Faker::Name.last_name,
        phone: phone,
        email: Faker::Internet.email
      )
    end
    if customer.valid?
      customer.save
      puts "Customer was created successfully : #{customer} with phone: #{customer.phone}"
    end
  end
  system("clear")
  customers = Customer.all
  restaurants = Restaurant.all
  customers.each_with_index do |customer, index|
    rand = rand(1..10)
    rand.times do
      noshow = NoShow.new(
        restaurant_id: restaurants.sample.id,
        customer_id: customer.id,
        date_service: Date.today-rand(190)
      )
      if noshow.valid?
        noshow.save
        puts "Noshow was created successfully for #{customer.name} by #{noshow.restaurant.name} : #{noshow}"
      end
    end
    puts "#{customer} (#{customer.phone}) have #{customer.no_shows.count} noshows"
    puts "#{index}/100"
    sleep(1)
    system("clear")
  end
  
  puts "End of seed"
  
end








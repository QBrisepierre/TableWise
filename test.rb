require "faker"
Faker::Config.locale = 'fr'

puts "Creating new customer"
regex = /^((0)[1-9]([0-9][0-9]){4})$/
phone = ""
result = false
while result == false
  phone = Faker::PhoneNumber.cell_phone
  puts phone
  if phone.match(regex)
    result = true
    puts "ok"
  else
    puts "false"
  end
end
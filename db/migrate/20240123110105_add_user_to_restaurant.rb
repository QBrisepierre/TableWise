class AddUserToRestaurant < ActiveRecord::Migration[7.1]
  def change
    add_reference :restaurants, :user, index: true
    add_foreign_key :restaurants, :users
  end
end

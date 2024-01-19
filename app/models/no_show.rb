class NoShow < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer

  validates :restaurant_id, :customer_id, :date_service, presence: true
end

class NoShow < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
end

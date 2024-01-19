class Restaurant < ApplicationRecord
  has_many :no_shows
  has_many :customers, through: :no_shows
end

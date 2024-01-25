class Restaurant < ApplicationRecord
  has_many :no_shows
  has_many :customers, through: :no_shows



  validates :name, :address, :phone, :email, presence: true
end

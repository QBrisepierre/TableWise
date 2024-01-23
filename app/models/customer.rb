class Customer < ApplicationRecord
  has_many :no_shows, dependent: :destroy
  has_many :restaurants, through: :no_shows

  validates :name, :phone, :email, presence: true
end

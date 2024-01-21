class Customer < ApplicationRecord
  has_many :restaurants

  validates :name, :phone, :email, presence: true
end

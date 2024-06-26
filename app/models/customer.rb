class Customer < ApplicationRecord
  has_many :no_shows, dependent: :destroy
  has_many :restaurants, through: :no_shows

  validates :name, :phone, :email, presence: true
  validates :phone, uniqueness: { case_sensitive: false }

  include PgSearch::Model
  pg_search_scope :search_by_email_and_phone,
  against: [ :email, :phone, :name ],
  using: {
    tsearch: { prefix: true, any_word: true}
  }
end

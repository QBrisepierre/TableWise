class CreateNoShows < ActiveRecord::Migration[7.1]
  def change
    create_table :no_shows do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.date :date_service

      t.timestamps
    end
  end
end

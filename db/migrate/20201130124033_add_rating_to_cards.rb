class AddRatingToCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :rating, :decimal, default: 0, precision: 5, scale: 2
    add_index :cards, :rating
  end
end

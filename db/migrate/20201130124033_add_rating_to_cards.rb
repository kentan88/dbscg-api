class AddRatingToCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :rating, :float, default: 0
    add_index :cards, :rating
  end
end

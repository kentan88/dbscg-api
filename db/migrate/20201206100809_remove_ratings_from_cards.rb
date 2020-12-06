class RemoveRatingsFromCards < ActiveRecord::Migration[6.0]
  def change
    remove_column :cards, :rating
  end
end

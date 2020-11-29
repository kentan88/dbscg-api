class RemoveSeriesAndEnergyFromCards < ActiveRecord::Migration[6.0]
  def change
    remove_column :cards, :series
    remove_column :cards, :energy
  end
end

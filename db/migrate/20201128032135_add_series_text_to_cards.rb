class AddSeriesTextToCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :series_text, :string
    add_index :cards, :series_text
  end
end

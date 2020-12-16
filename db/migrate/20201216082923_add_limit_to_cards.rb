class AddLimitToCards < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :limit, :integer, default: 0
  end
end
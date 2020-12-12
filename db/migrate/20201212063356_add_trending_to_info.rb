class AddTrendingToInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :infos, :trending, :jsonb, default: {}
  end
end

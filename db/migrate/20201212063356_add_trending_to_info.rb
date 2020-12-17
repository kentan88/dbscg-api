class AddTrendingToInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :infos, :trending, :jsonb, default: {}
    add_column :infos, :pricing, :json, array: true, default: []
    add_column :infos, :tcg_mapping, :jsonb, default: {}
  end
end

class AddPricingToInfo < ActiveRecord::Migration[6.0]
  def change
    drop_table :pricings
    add_column :infos, :pricing, :text, array: true, default: []
    add_column :infos, :tcg_mapping, :jsonb, default: {}
  end
end

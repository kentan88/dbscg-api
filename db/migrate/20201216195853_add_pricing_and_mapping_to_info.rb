class AddPricingAndMappingToInfo < ActiveRecord::Migration[6.0]
  def change
    remove_column :infos, :pricing
    remove_column :infos, :tcg_mapping

    add_column :infos, :pricing, :json, array: true, default: []
    add_column :infos, :tcg_mapping, :jsonb, default: {}
  end
end

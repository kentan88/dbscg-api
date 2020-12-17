class ChangeTcgMappingToArray < ActiveRecord::Migration[6.0]
  def change
    remove_column :infos, :tcg_mapping
    add_column :infos, :tcg_mapping, :json, array: true, default: []
  end
end

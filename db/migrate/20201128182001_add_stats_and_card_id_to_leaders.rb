class AddStatsAndCardIdToLeaders < ActiveRecord::Migration[6.0]
  def change
    add_reference :leaders, :card, null: false, index: true
    add_column :leaders, :stats, :jsonb, default: '{}'
  end
end

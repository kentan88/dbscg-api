class RemoveLeaders < ActiveRecord::Migration[6.0]
  def change
    drop_table :leaders
  end
end

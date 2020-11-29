class CreateLeaders < ActiveRecord::Migration[6.0]
  def change
    create_table :leaders do |t|
      t.references :card, null: false, index: true
      t.string :title
      t.string :title_back
      t.integer :power
      t.integer :power_back
      t.string :number
      t.text :stats, :jsonb, default: '{}'
    end

    add_index :leaders, :title
    add_index :leaders, :title_back
    add_index :leaders, :number
  end
end

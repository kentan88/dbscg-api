class CreatePricings < ActiveRecord::Migration[6.0]
  def change
    create_table :pricings do |t|
      t.string :card_number, null: false
      t.float :low_price, default: 0
      t.float :mid_price, default: 0
      t.float :high_price, default: 0
      t.float :market_price, default: 0
      t.string :type

      t.timestamps
    end

    drop_table :group_users
    drop_table :groups

    add_index :pricings, :card_number
    add_index :pricings, :low_price
    add_index :pricings, :mid_price
    add_index :pricings, :high_price
    add_index :pricings, :market_price
    add_index :pricings, :type

  end
end

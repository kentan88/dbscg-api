class RemoveDeckCards < ActiveRecord::Migration[6.0]
  def change
    drop_table :deck_cards
  end
end

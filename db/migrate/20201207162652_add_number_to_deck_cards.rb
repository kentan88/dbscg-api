class AddNumberToDeckCards < ActiveRecord::Migration[6.0]
  def change
    add_column :deck_cards, :number, :string
    add_index :deck_cards, :number
    change_column_null :deck_cards, :card_id, true
  end
end
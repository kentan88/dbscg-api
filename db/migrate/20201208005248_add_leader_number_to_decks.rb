class AddLeaderNumberToDecks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :decks, :card_id, true
    add_column :decks, :leader_number, :string
  end
end

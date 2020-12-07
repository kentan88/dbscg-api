class AddTypeToDeckCards < ActiveRecord::Migration[6.0]
  def change
    add_column :deck_cards, :type, :string

    DeckCard.update_all({type: "main"})
  end
end

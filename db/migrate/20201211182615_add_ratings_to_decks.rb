class AddRatingsToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :user_ratings, :jsonb, default: {}
    add_column :decks, :rating, :float, default: 0
    add_index :decks, :rating
  end
end

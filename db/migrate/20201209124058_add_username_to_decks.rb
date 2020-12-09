class AddUsernameToDecks < ActiveRecord::Migration[6.0]
  def change
    add_column :decks, :username, :string
  end
end

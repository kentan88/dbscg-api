class CreateDecks < ActiveRecord::Migration[6.0]
  def change
    create_table :decks do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.boolean :private, default: false
      t.string :leader_number
      t.boolean :draft, default: false

      t.timestamps
    end

    add_index :decks, :private
    add_index :decks, :draft
  end
end

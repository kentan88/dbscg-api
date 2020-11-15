class CreateDeckCards < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_cards do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.integer :quantity
    end
  end
end

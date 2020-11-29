class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :title, null: false
      t.string :title_back
      t.string :number, null: false
      t.string :series
      t.string :rarity, null: false
      t.string :type, null: false
      t.string :color
      t.integer :energy
      t.text :energy_text
      t.integer :combo_energy
      t.integer :combo_power
      t.integer :power
      t.integer :power_back
      t.string :character
      t.string :special_trait
      t.string :era
      t.string :skills, array: true, default: []
      t.text :skills_text
      t.string :skills_back, array: true, default: []
      t.text :skills_back_text
    end

    add_index :cards, :title
    add_index :cards, :title_back
    add_index :cards, :number
    add_index :cards, :rarity
    add_index :cards, :type
    add_index :cards, :color
    add_index :cards, :energy
    add_index :cards, :combo_energy
    add_index :cards, :combo_power
    add_index :cards, :power
    add_index :cards, :power_back
    add_index :cards, :character
    add_index :cards, :special_trait
    add_index :cards, :era
    add_index :cards, :skills_text
    add_index :cards, :skills_back_text
    add_index :cards, :series
  end
end

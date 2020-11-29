class AddCardNumberToLeaders < ActiveRecord::Migration[6.0]
  def change
    add_column :leaders, :card_number, :string
    add_index :leaders, :card_number

    Leader.includes(:card).all.each do |leader|
      leader.number = leader.card.number
      leader.save!
    end
  end
end

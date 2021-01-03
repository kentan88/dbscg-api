require 'rails_helper'

def seed_cards
  filename = "#{Rails.root}/spec/fixtures/cards.json"
  file = File.read(filename)
  data_hash = JSON.parse(file)

  data_hash.each do |data|
    card = Card.new(data)
    card.title = card.title.strip
    card.skills_text = nil if card.skills_text == "-"
    if card.save
      puts "#{card.number} created"
    end
  end
end

RSpec.describe DBSCG::Game do
  before(:all) do
    seed_cards
    @user_1 = User.create(username: "foo", email: "foo@example.com", password: 11111111, password_confirmation: 11111111)
    @user_2 = User.create(username: "bar", email: "bar@example.com", password: 11111111, password_confirmation: 11111111)
    p1_main_deck_cards = {"P-075"=>3, "P-123"=>4, "P-230"=>1, "BT1-005"=>4, "BT5-115"=>4, "BT9-134"=>3, "SD14-02"=>4, "SD14-03"=>4, "SD14-04"=>4, "SD14-05"=>4, "BT10-126"=>3, "BT10-130"=>4, "BT11-127"=>3, "BT11-130"=>4, "BT11-144"=>4}
    p2_main_deck_cards = {"P-223"=>2, "P-255"=>1, "P-256"=>1, "BT5-075"=>1, "BT9-099"=>4, "DB1-057"=>2, "DB2-069"=>3, "EX10-02"=>2, "EX13-14"=>4, "EX13-15"=>4, "EX13-16"=>4, "EX13-34"=>1, "BT10-063"=>2, "BT10-067"=>2, "BT10-075"=>4, "BT10-088"=>4, "BT10-152"=>1, "BT11-063"=>4, "BT11-079"=>2, "BT11-081"=>1, "BT11-090"=>1}
    @deck_1 = Deck.create!(user: @user_1, leader_number: "SD14-01", name: "Player 1 Deck", main_deck_cards: p1_main_deck_cards)
    @deck_2 = Deck.create!(user: @user_2, leader_number: "P-027", name: "Player 2 Deck", main_deck_cards: p2_main_deck_cards)
  end

  before(:each) do
    @game = DBSCG::Game.new(@user_1, @deck_1, @user_2, @deck_2)
  end

  it "should have set the turn" do
    expect(@game).to be_valid
    expect(@game.turn).to_not be_nil
  end
end

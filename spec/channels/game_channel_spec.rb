require "rails_helper"

def seed_cards
  Dir.glob("#{Rails.root}/spec/fixtures/**").sort.each do |filename|
    file = File.read(filename)
    data_hash = JSON.parse(file)

    data_hash.each do |data|
      REDIS.hset("card_info:#{data["number"]}", data.to_h.to_a.flatten)
      data.delete("specified_energy")
      card = Card.new(data)
      card.title = card.title.strip
      card.rarity = "-"
      card.skills_text = nil if card.skills_text
      card.save!
    end
  end
end

RSpec.describe ApplicationCable::Connection, :type => :channel do
  before(:each) do
    @token = "eyJhbGciOiJub25lIn0.eyJpZCI6MSwidXNlcm5hbWUiOiJrZW50YW4iLCJlbWFpbCI6ImtlbnRhbjAxMzBAZ21haWwuY29tIiwiY3JlYXRlZF9hdCI6IjIwMjAtMTEtMzBUMTg6MzU6NTEuNjY3WiIsInVwZGF0ZWRfYXQiOiIyMDIwLTExLTMwVDE4OjM1OjUxLjY2N1oifQ."
    @user = User.create(username: "kentan", email: "kentan@example.com", password: 11111111, password_confirmation: 11111111)
  end

  it "successfully connects" do
    connect "/cable?token=#{@token}"
    expect(connection.current_user).to eq @user
  end
end

RSpec.describe GameChannel, :type => :channel do
  before(:all) do
    REDIS.flushdb
    seed_cards
    @user_1 = User.create(username: "foo", email: "foo@example.com", password: 11111111, password_confirmation: 11111111)
    @user_2 = User.create(username: "bar", email: "bar@example.com", password: 11111111, password_confirmation: 11111111)
    p1_main_deck_cards = {
        "BT1-033" => 4,
        "BT1-040" => 4,
        "BT1-050" => 4,
        "BT1-054" => 2,
        "BT1-055" => 4,
        "BT1-035" => 3,
        "BT1-039" => 3,
        "BT1-046" => 4,
        "BT1-037" => 4,
        "SD1-04" => 2,
        "BT1-034" => 2,
        "BT1-042" => 2,
        "BT1-044" => 4,
        "SD1-03" => 2,
        "SD1-05" => 2,
        "SD1-02" => 4
    }
    p2_main_deck_cards = {
        "SD8-05" => 2,
        "BT6-063" => 4,
        "BT6-065" => 4,
        "BT6-069" => 4,
        "BT6-076" => 4,
        "BT6-078" => 4,
        "BT1-107" => 4,
        "BT1-109" => 4,
        "SD8-09" => 2,
        "SD8-10" => 2,
        "SD8-04" => 2,
        "SD8-06" => 2,
        "SD8-03" => 2,
        "BT6-062" => 4,
        "SD8-07" => 2,
        "SD8-08" => 2,
        "SD8-02" => 2
    }
    @deck_1 = Deck.create!(user: @user_1, leader_number: "SD1-01", name: "Player 1 Deck", main_deck_cards: p1_main_deck_cards)
    @deck_2 = Deck.create!(user: @user_2, leader_number: "SD1-01", name: "Player 2 Deck", main_deck_cards: p1_main_deck_cards)
    # @deck_2 = Deck.create!(user: @user_2, leader_number: "SD8-01", name: "Player 2 Deck", main_deck_cards: p2_main_deck_cards)

    @token_1 = JWT.encode @user_1.as_json, "secret", 'none'
    @token_2 = JWT.encode @user_2.as_json, "secret", 'none'

    @id = (0...12).map { ('a'..'z').to_a[rand(26)] }.join

    DBSCG::Game.create(@id)
    @game = DBSCG::Game.find(@id)
  end

  it "p1 join" do
    player_1_subscribe

    expect(subscription).to be_confirmed
    expect(@game.player_1).to eq("")
    expect(@game.player_2).to eq("")

    perform :join
    expect(@game.player_1).to eq(@user_1.username)
    expect(@game.player_2).to eq("")
    expect(@game.status).to eq(STATUS_LIST[:NOT_STARTED])
    expect(@game.first_turn).to eq(false)
    expect(@game.all_players_present?).to eq(false)
    expect(@game.battle_area(PLAYER_1).length).to eq(0)
    expect(@game.combo_area(PLAYER_1).length).to eq(0)
    expect(@game.deck_area(PLAYER_1).length).to eq(50 - STARTING_HAND_COUNT)
    expect(@game.drop_area(PLAYER_1).length).to eq(0)
    expect(@game.energy_area(PLAYER_1).length).to eq(0)
    expect(@game.hand(PLAYER_1).length).to eq(STARTING_HAND_COUNT)
    expect(@game.leader_area(PLAYER_1).length).to eq(1)
    expect(@game.life_area(PLAYER_1).length).to eq(0)
    expect(@game.phase).to eq("")
    expect([PLAYER_1, PLAYER_2]).to include(@game.turn_player)
  end

  it "p2 join" do
    player_2_subscribe

    expect(subscription).to be_confirmed
    expect(@game.player_1).to eq(@user_1.username)
    expect(@game.player_2).to eq("")

    perform :join
    expect(@game.player_1).to eq(@user_1.username)
    expect(@game.player_2).to eq(@user_2.username)
    expect(@game.status).to eq(STATUS_LIST[:STARTED])
    expect(@game.first_turn).to eq(true)
    expect(@game.all_players_present?).to eq(true)
    expect(@game.battle_area(PLAYER_2).length).to eq(0)
    expect(@game.combo_area(PLAYER_2).length).to eq(0)
    expect(@game.deck_area(PLAYER_2).length).to eq(50 - STARTING_HAND_COUNT)
    expect(@game.drop_area(PLAYER_2).length).to eq(0)
    expect(@game.energy_area(PLAYER_2).length).to eq(0)
    expect(@game.hand(PLAYER_2).length).to eq(STARTING_HAND_COUNT)
    expect(@game.leader_area(PLAYER_2).length).to eq(1)
    expect(@game.life_area(PLAYER_2).length).to eq(0)
    expect(@game.phase).to eq("")
    expect([PLAYER_1, PLAYER_2]).to include(@game.turn_player)
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.auto_action).to eq("start_mulligan_phase")
  end

  it "start_mulligan_phase" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    player_1_subscribe

    perform :start_mulligan_phase
    player_1_hand_card_ids = @game.hand(PLAYER_1).collect { |card| card[ID] }
    expect(@game.cards_selectable(PLAYER_1)).to eq(player_1_hand_card_ids)
    expect(@game.phase).to eq(PHASE_LIST[:MULLIGAN_PHASE])
    expect(@game.player_actions).to eq("mulligan")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    player_1_subscribe

    player_1_before_select_hand_cards = @game.hand(PLAYER_1)
    selected_card_1 = player_1_before_select_hand_cards[0]
    selected_card_2 = player_1_before_select_hand_cards[1]
    selected_card_3 = player_1_before_select_hand_cards[5]

    perform :select_card, card: selected_card_1[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)

    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID]])

    perform :select_card, card: selected_card_3[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID], selected_card_3[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_3[ID]])
  end

  it "player_1 mulligan" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    player_1_subscribe

    player_1_before_exchange_hand_cards = @game.hand(PLAYER_1)

    perform :mulligan
    player_1_after_exchange_hand_cards = @game.hand(PLAYER_1)

    expect(player_1_after_exchange_hand_cards[0]).to eql(player_1_before_exchange_hand_cards[1])
    expect(player_1_after_exchange_hand_cards[1]).to eql(player_1_before_exchange_hand_cards[2])
    expect(player_1_after_exchange_hand_cards[2]).to eql(player_1_before_exchange_hand_cards[3])
    expect(player_1_after_exchange_hand_cards[3]).to eql(player_1_before_exchange_hand_cards[4])
    expect(@game.hand(PLAYER_1).length).to eq(STARTING_HAND_COUNT)
    expect(@game.deck_area(PLAYER_1).length).to eq(50 - STARTING_HAND_COUNT - NUMBER_OF_LIFEPOINTS)
    expect(@game.life_area(PLAYER_1).length).to eq(NUMBER_OF_LIFEPOINTS)
    expect(@game.battle_area(PLAYER_1).length).to eq(0)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([])
    expect(@game.cards_selectable(PLAYER_1)).to eq([])
    expect(@game.player_1_mulliganed).to eq(true)
    expect(@game.player_2_mulliganed).to eq(false)
    expect(@game.all_players_mulliganed?).to eq(false)
    expect(@game.player_1_action_messages).to eq("Waiting for opponent...")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.step).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    player_2_subscribe

    player_2_before_select_hand_cards = @game.hand(PLAYER_2)
    selected_card_1 = player_2_before_select_hand_cards[0]
    selected_card_2 = player_2_before_select_hand_cards[1]
    selected_card_3 = player_2_before_select_hand_cards[5]

    perform :select_card, card: selected_card_1[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)

    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID]])

    perform :select_card, card: selected_card_3[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_2[ID], selected_card_3[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID], selected_card_3[ID]])
  end

  it "player_2 mulligan" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_2_subscribe

    player_2_before_exchange_hand_cards = @game.hand(PLAYER_2)

    perform :mulligan
    player_2_after_exchange_hand_cards = @game.hand(PLAYER_2)

    expect(player_2_after_exchange_hand_cards[0]).to eql(player_2_before_exchange_hand_cards[1])
    expect(player_2_after_exchange_hand_cards[1]).to eql(player_2_before_exchange_hand_cards[2])
    expect(player_2_after_exchange_hand_cards[2]).to eql(player_2_before_exchange_hand_cards[3])
    expect(player_2_after_exchange_hand_cards[3]).to eql(player_2_before_exchange_hand_cards[4])
    expect(@game.hand(PLAYER_2).length).to eq(STARTING_HAND_COUNT)
    expect(@game.deck_area(PLAYER_2).length).to eq(50 - STARTING_HAND_COUNT - NUMBER_OF_LIFEPOINTS)
    expect(@game.life_area(PLAYER_2).length).to eq(NUMBER_OF_LIFEPOINTS)
    expect(@game.battle_area(PLAYER_2).length).to eq(0)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([])
    expect(@game.cards_selectable(PLAYER_2)).to eq([])
    expect(@game.player_1_mulliganed).to eq(true)
    expect(@game.player_2_mulliganed).to eq(true)
    expect(@game.all_players_mulliganed?).to eq(true)
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.auto_action).to eq("start_turn")
  end

  it "player_1 start_turn" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_1_subscribe

    perform :start_turn
    expect(@game.first_turn).to eq(true)

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_charge_phase")
  end

  it "player_1 start_charge_phase" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_1_subscribe

    perform :start_charge_phase
    player_1_hand_card_ids = @game.hand(PLAYER_1).collect { |card| card[ID] }
    expect(@game.first_turn).to eq(true)
    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])
    expect(@game.cards_selectable(PLAYER_1)).to eq(player_1_hand_card_ids)
    expect(@game.cards_selectable(PLAYER_2)).to eq([])

    expect(@game.player_1_action_messages).to eq("Select a card to use as energy from your hand.")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("charge")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 charge" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_1_subscribe

    player_1_hand = @game.hand(PLAYER_1)
    player_1_selected_card = player_1_hand.first
    player_1_selected_card_2 = player_1_hand.last

    perform :select_card, card: player_1_selected_card[ID]
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([player_1_selected_card[ID]])

    perform :select_card, card: player_1_selected_card_2[ID]
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([player_1_selected_card[ID]])

    perform :select_card, card: player_1_selected_card[ID]
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([])

    perform :select_card, card: player_1_selected_card[ID]
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([player_1_selected_card[ID]])

    player_1_before_charge_hand_cards = @game.hand(PLAYER_1)
    player_1_before_charge_energy_area = @game.energy_area(PLAYER_1)
    expect(player_1_before_charge_energy_area).to eq([])

    charge_card = player_1_before_charge_hand_cards.first
    perform :charge, card: charge_card

    player_1_after_charge_hand_cards = @game.hand(PLAYER_1)
    player_1_after_charge_energy_area = @game.energy_area(PLAYER_1)

    expect(player_1_after_charge_hand_cards.length).to eq(5)
    expect(player_1_after_charge_hand_cards.first(5)).to eq(player_1_before_charge_hand_cards.last(5))
    expect(player_1_after_charge_energy_area).to eq([player_1_selected_card])
    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_main_phase")
  end

  it "player_1 start_main_phase" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_1_subscribe

    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])
    expect(@game.player_actions).to eq("")

    perform :start_main_phase
    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)
    allow_any_instance_of(DBSCG::Game).to receive(:hand).and_return(
        [{"id"=>"BT1-033__zobrks", "number"=>"BT1-033", "mode"=>"ACTIVE"}, {"id"=>"BT1-046__nhoiuw", "number"=>"BT1-046", "mode"=>"ACTIVE"}, {"id"=>"BT1-044__mvptum", "number"=>"BT1-044", "mode"=>"ACTIVE"}, {"id"=>"BT1-050__pobkuv", "number"=>"BT1-050", "mode"=>"ACTIVE"}, {"id"=>"BT1-054__jwuaak", "number"=>"BT1-054", "mode"=>"ACTIVE"}]
    )
    allow_any_instance_of(DBSCG::Game).to receive(:get_card_state).and_return(
        {"id"=>"BT1-033__zobrks", "mode"=>"ACTIVE", "area"=>"hand", "player"=>"player_1"}
    )

    player_1_subscribe

    player_1_before_select_hand_cards = @game.hand(PLAYER_1)
    selected_card_1 = player_1_before_select_hand_cards[0]
    selected_card_2 = player_1_before_select_hand_cards[1]

    perform :select_card, card: selected_card_1[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_1_after_select_hand_cards = @game.hand(PLAYER_1)
    expect(player_1_after_select_hand_cards).to eql(player_1_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("declare_play")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 declare_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    player_1_subscribe

    perform :declare_play

    player_1_energy_area = @game.energy_area(PLAYER_1)
    player_1_energy_area_cards_ids = player_1_energy_area.map { |card| card[ID] }
    expect(@game.cards_selectable(PLAYER_1)).to eq(player_1_energy_area_cards_ids)
    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_1_action_messages).to eq("Please select cards(s)")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost|cancel")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_1_subscribe

    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost|cancel")
    expect(@game.player_1_action_messages).to eq("Please select cards(s)")
    expect(@game.energy_area(PLAYER_1).length).to eq(1)

    player_1_before_select_energy_area_cards = @game.energy_area(PLAYER_1)
    selected_card_1 = player_1_before_select_energy_area_cards[0]

    perform :select_card, card: selected_card_1[ID]
    player_1_after_select_energy_area_cards = @game.energy_area(PLAYER_1)
    expect(player_1_after_select_energy_area_cards).to eql(player_1_before_select_energy_area_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:ENERGY_AREA])).to eq([selected_card_1[ID]])

    expect(@game.player_1_action_messages).to eq("Please select cards(s)")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 pay_energy_cost" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_1_subscribe

    player_1_before_pay_energy_cost_energy_area_cards_selected = @game.cards_selected(PLAYER_1, AREA_LIST[:ENERGY_AREA])
    player_1_before_pay_energy_cost_hand_cards_selected = @game.cards_selected(PLAYER_1, AREA_LIST[:HAND])
    player_1_before_pay_energy_cost_energy_area_cards_selected.each do |card|
      expect(@game.get_card_state(PLAYER_1, card)[MODE]).to eq(MODE_LIST[:ACTIVE])
    end

    perform :pay_energy_cost
    player_1_after_pay_energy_cost_energy_area_cards_selected = @game.cards_selected(PLAYER_1, AREA_LIST[:ENERGY_AREA])
    player_1_after_pay_energy_cost_hand_cards_selected = @game.cards_selected(PLAYER_1, AREA_LIST[:HAND])

    expect(player_1_before_pay_energy_cost_hand_cards_selected).to eq(player_1_after_pay_energy_cost_hand_cards_selected)
    expect(@game.cards_selectable(PLAYER_1)).to eq([])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("declare_counter_play")

    player_1_after_pay_energy_cost_energy_area_cards_selected.each do |card|
      expect(@game.get_card_state(PLAYER_1, card)[MODE]).to eq(MODE_LIST[:RESTED])
    end
  end

  it "player_2 declare_counter_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)

    player_2_subscribe
    perform :declare_counter_play

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Select Cards to Counter")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("no_counter_play")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 no_counter_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)

    player_2_subscribe
    perform :no_counter_play

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("play")
  end

  it "player_1 play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)

    player_1_subscribe

    player_1_before_play_hand_cards = @game.hand(PLAYER_1)
    player_1_before_play_hand_card_selected = @game.cards_selected(PLAYER_1, AREA_LIST[:HAND])[0]

    expect(@game.battle_area(PLAYER_1).length).to eq(0)
    perform :play

    player_1_after_play_hand_cards = @game.hand(PLAYER_1)
    player_1_after_battle_area = @game.battle_area(PLAYER_1)

    expect(player_1_after_play_hand_cards).to eq(player_1_before_play_hand_cards)
    expect(player_1_after_battle_area.length).to eq(1)
    expect(player_1_after_battle_area[0][ID]).to eq(player_1_before_play_hand_card_selected)

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_1_subscribe

    player_1_before_select_battle_area_cards = @game.battle_area(PLAYER_1)
    selected_card_1 = player_1_before_select_battle_area_cards[0]

    perform :select_card, card: selected_card_1[ID]
    player_1_after_select_battle_area_cards = @game.battle_area(PLAYER_1)
    expect(player_1_after_select_battle_area_cards).to eql(player_1_before_select_battle_area_cards)
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:BATTLE_AREA])).to eq([selected_card_1[ID]])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("declare_attack")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 declare_attack" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)

    player_1_subscribe

    player_1_before_select_battle_area_cards = @game.battle_area(PLAYER_1)
    perform :declare_attack

    player_1_after_select_battle_area_cards = @game.battle_area(PLAYER_1)
    expect(player_1_after_select_battle_area_cards).to eql(player_1_before_select_battle_area_cards)

    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:BATTLE_AREA])).to eq([])
    expect(@game.cards_selectable(PLAYER_1)).to eq([])
    expect(@game.attacker).to eq("")
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player end_turn 1" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)

    player_1_subscribe

    perform :end_turn
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_call_original

    expect(@game.phase).to eq(PHASE_LIST[:END_PHASE])
    expect(@game.first_turn).to eq(false)
    expect(@game.turn_player).to eq(PLAYER_2)

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_turn")
  end


  ##########
  ##########

  it "player_2 start_turn" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    perform :start_turn
    expect(@game.first_turn).to eq(false)
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("draw_card")
  end

  it "player_2 draw_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    player_1_before_draw_cards = @game.hand(PLAYER_2)
    expect(player_1_before_draw_cards.length).to eq(6)

    perform :draw_card
    player_1_after_draw_cards = @game.hand(PLAYER_2)
    expect(player_1_after_draw_cards.length).to eq(7)
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_charge_phase")
  end

  it "player_2 start_charge_phase" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    perform :start_charge_phase
    player_2_hand_card_ids = @game.hand(PLAYER_2).collect { |card| card[ID] }
    expect(@game.first_turn).to eq(false)
    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])
    expect(@game.cards_selectable(PLAYER_2)).to eq(player_2_hand_card_ids)
    expect(@game.cards_selectable(PLAYER_1)).to eq([])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Select a card to use as energy from your hand.")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("charge")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 charge" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    player_2_hand = @game.hand(PLAYER_2)
    player_2_selected_card = player_2_hand.first
    player_2_selected_card_2 = player_2_hand.last

    perform :select_card, card: player_2_selected_card[ID]
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([player_2_selected_card[ID]])

    perform :select_card, card: player_2_selected_card_2[ID]
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([player_2_selected_card[ID]])

    perform :select_card, card: player_2_selected_card[ID]
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([])

    perform :select_card, card: player_2_selected_card[ID]
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([player_2_selected_card[ID]])

    player_2_before_charge_hand_cards = @game.hand(PLAYER_2)
    player_2_before_charge_energy_area = @game.energy_area(PLAYER_2)
    expect(player_2_before_charge_energy_area).to eq([])

    charge_card = player_2_before_charge_hand_cards.first
    perform :charge, card: charge_card

    player_2_after_charge_hand_cards = @game.hand(PLAYER_2)
    player_2_after_charge_energy_area = @game.energy_area(PLAYER_2)

    expect(player_2_after_charge_hand_cards.length).to eq(6)
    expect(player_2_after_charge_hand_cards.first(6)).to eq(player_2_before_charge_hand_cards.last(6))
    expect(player_2_after_charge_energy_area).to eq([player_2_selected_card])
    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_main_phase")
  end

  it "player_2 start_main_phase" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    expect(@game.phase).to eq(PHASE_LIST[:CHARGE_PHASE])
    expect(@game.player_actions).to eq("")

    perform :start_main_phase
    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)
    allow_any_instance_of(DBSCG::Game).to receive(:hand).and_return(
      [{"id"=>"BT1-033__zobrks", "number"=>"BT1-033", "mode"=>"ACTIVE"},
       {"id"=>"BT1-046__nhoiuw", "number"=>"BT1-046", "mode"=>"ACTIVE"},
       {"id"=>"BT1-044__mvptum", "number"=>"BT1-044", "mode"=>"ACTIVE"},
       {"id"=>"BT1-050__pobkuv", "number"=>"BT1-050", "mode"=>"ACTIVE"},
       {"id"=>"BT1-054__jwuaak", "number"=>"BT1-054", "mode"=>"ACTIVE"}]
    )
    allow_any_instance_of(DBSCG::Game).to receive(:get_card_state).and_return(
      {"id"=>"BT1-033__zobrks", "mode"=>"ACTIVE", "area"=>"hand", "player"=>"player_2"}
    )

    player_2_subscribe

    player_2_before_select_hand_cards = @game.hand(PLAYER_2)
    selected_card_1 = player_2_before_select_hand_cards[0]
    selected_card_2 = player_2_before_select_hand_cards[1]

    perform :select_card, card: selected_card_1[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    perform :select_card, card: selected_card_2[ID]
    player_2_after_select_hand_cards = @game.hand(PLAYER_2)
    expect(player_2_after_select_hand_cards).to eql(player_2_before_select_hand_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:HAND])).to eq([selected_card_1[ID]])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("declare_play")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 declare_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    player_2_subscribe

    perform :declare_play

    player_2_energy_area = @game.energy_area(PLAYER_2)
    player_2_energy_area_cards_ids = player_2_energy_area.map { |card| card[ID] }
    expect(@game.cards_selectable(PLAYER_2)).to eq(player_2_energy_area_cards_ids)
    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Please select cards(s)")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost|cancel")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_2_subscribe

    expect(@game.phase).to eq(PHASE_LIST[:MAIN_PHASE])
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost|cancel")
    expect(@game.player_2_action_messages).to eq("Please select cards(s)")
    expect(@game.energy_area(PLAYER_2).length).to eq(1)

    player_2_before_select_energy_area_cards = @game.energy_area(PLAYER_2)
    selected_card_1 = player_2_before_select_energy_area_cards[0]

    perform :select_card, card: selected_card_1[ID]
    player_2_after_select_energy_area_cards = @game.energy_area(PLAYER_2)
    expect(player_2_after_select_energy_area_cards).to eql(player_2_before_select_energy_area_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:ENERGY_AREA])).to eq([selected_card_1[ID]])

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Please select cards(s)")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("pay_energy_cost")
    expect(@game.player_actions).to eq("pay_energy_cost")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 pay_energy_cost" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_2_subscribe

    player_2_before_pay_energy_cost_energy_area_cards_selected = @game.cards_selected(PLAYER_2, AREA_LIST[:ENERGY_AREA])
    player_2_before_pay_energy_cost_hand_cards_selected = @game.cards_selected(PLAYER_2, AREA_LIST[:HAND])
    player_2_before_pay_energy_cost_energy_area_cards_selected.each do |card|
      expect(@game.get_card_state(PLAYER_2, card)[MODE]).to eq(MODE_LIST[:ACTIVE])
    end

    perform :pay_energy_cost
    player_2_after_pay_energy_cost_energy_area_cards_selected = @game.cards_selected(PLAYER_2, AREA_LIST[:ENERGY_AREA])
    player_2_after_pay_energy_cost_hand_cards_selected = @game.cards_selected(PLAYER_2, AREA_LIST[:HAND])

    expect(player_2_before_pay_energy_cost_hand_cards_selected).to eq(player_2_after_pay_energy_cost_hand_cards_selected)
    expect(@game.cards_selectable(PLAYER_2)).to eq([])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("declare_counter_play")

    player_2_after_pay_energy_cost_energy_area_cards_selected.each do |card|
      expect(@game.get_card_state(PLAYER_2, card)[MODE]).to eq(MODE_LIST[:RESTED])
    end
  end

  it "player_1 declare_counter_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)

    player_1_subscribe
    perform :declare_counter_play

    expect(@game.player_1_action_messages).to eq("Select Cards to Counter")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("no_counter_play")
    expect(@game.auto_action).to eq("")
  end

  it "player_1 no_counter_play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_1)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_1)

    player_1_subscribe
    perform :no_counter_play

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("play")
  end

  it "player_2 play" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)

    player_2_subscribe

    player_2_before_play_hand_cards = @game.hand(PLAYER_2)
    player_2_before_play_hand_card_selected = @game.cards_selected(PLAYER_2, AREA_LIST[:HAND])[0]

    expect(@game.battle_area(PLAYER_2).length).to eq(0)
    perform :play

    player_2_after_play_hand_cards = @game.hand(PLAYER_2)
    player_2_after_battle_area = @game.battle_area(PLAYER_2)

    expect(player_2_after_play_hand_cards).to eq(player_2_before_play_hand_cards)
    expect(player_2_after_battle_area.length).to eq(1)
    expect(player_2_after_battle_area[0][ID]).to eq(player_2_before_play_hand_card_selected)

    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_2_subscribe

    player_2_before_select_battle_area_cards = @game.battle_area(PLAYER_2)
    selected_card_1 = player_2_before_select_battle_area_cards[0]

    perform :select_card, card: selected_card_1[ID]
    player_2_after_select_battle_area_cards = @game.battle_area(PLAYER_2)
    expect(player_2_after_select_battle_area_cards).to eql(player_2_before_select_battle_area_cards)
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:BATTLE_AREA])).to eq([selected_card_1[ID]])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("declare_attack")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 declare_attack" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)

    player_2_subscribe

    player_2_before_select_battle_area_cards = @game.battle_area(PLAYER_2)
    expect(player_2_before_select_battle_area_cards[0][MODE]).to eq(MODE_LIST[:ACTIVE])

    perform :declare_attack

    player_2_after_select_battle_area_cards = @game.battle_area(PLAYER_2)
    expect(player_2_after_select_battle_area_cards[0][MODE]).to eq(MODE_LIST[:RESTED])

    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:BATTLE_AREA])).to eq([])
    expect(@game.cards_selectable(PLAYER_2).length).to eq(1) # just the leader
    expect(@game.attacker).to eq(player_2_after_select_battle_area_cards[0][ID])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Please select a target.")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("select_attack_target")
    expect(@game.player_actions).to eq("battle|cancel")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 select_card" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_2_subscribe

    player_1_before_select_leader_area_cards = @game.leader_area(PLAYER_1)
    selected_card_1 = player_1_before_select_leader_area_cards[0]

    perform :select_card, card: selected_card_1[ID]
    expect(@game.cards_selected(PLAYER_1, AREA_LIST[:LEADER_AREA])).to eq([selected_card_1[ID]])
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("Please select a target.")
    expect(@game.requires_player_1_response).to eq(false)
    expect(@game.requires_player_2_response).to eq(true)
    expect(@game.step).to eq("select_attack_target")
    expect(@game.player_actions).to eq("battle|cancel")
    expect(@game.auto_action).to eq("")
  end

  it "player_2 battle" do
    allow_any_instance_of(DBSCG::Game).to receive(:can_respond?).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:turn_player).and_return(PLAYER_2)
    allow_any_instance_of(DBSCG::Game).to receive(:is_card_playable?).and_return(true)

    player_2_subscribe

    player_1_selected_leader_card = @game.cards_selected(PLAYER_1, AREA_LIST[:LEADER_AREA])[0]

    perform :battle
    expect(@game.cards_selected(PLAYER_2, AREA_LIST[:BATTLE_AREA])).to eq([])
    expect(@game.cards_selectable(PLAYER_2)).to eq([])
    expect(@game.target).to eq(player_1_selected_leader_card)
    expect(@game.player_1_action_messages).to eq("")
    expect(@game.player_2_action_messages).to eq("")
    expect(@game.requires_player_1_response).to eq(true)
    expect(@game.requires_player_2_response).to eq(false)
    expect(@game.step).to eq("")
    expect(@game.player_actions).to eq("")
    expect(@game.auto_action).to eq("start_battle_phase")
  end

  private

  def player_1_subscribe
    subscribe game_id: @game.id, token: @token_1, deck_id: @deck_1.id
  end

  def player_2_subscribe
    subscribe game_id: @game.id, token: @token_2, deck_id: @deck_2.id
  end
end
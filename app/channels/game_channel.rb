class GameChannel < ApplicationCable::Channel
  def subscribed
    @game_id = params[:game_id]
    @deck_id = params[:deck_id]
    @user = User.find(user_id)
    @game = DBSCG::Game.find(@game_id)

    stream_from "game_#{@game_id}"
  end

  def unsubscribed
  end

  def join
    set_players
    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "#{@user.username} has joined the game."}

    if @game.status != STATUS_LIST[:STARTED]
      @deck = Deck.find(@deck_id)
      @game.set_deck_leader(@player, deck_leader)
      @game.set_deck(@player, deck_cards)

      # 5-2-1-3. The trigger condition for “When this card is placed in
      # the Leader Area” is fulfilled, and then a checkpoint occurs.
      leader_card = @game.draw_top_card_from_deck(@player)
      @game.add_card_to_leader_area(@player, leader_card)

      # 5-2-1-4. Each player shuffles their deck. Then, each player
      # places their deck face-down in their Deck Area.
      @game.shuffle_deck(@player)

      # 5-2-1-5. Decide which player goes first randomly
      @game.turn_player = [@player, @opponent].sample

      # 5-2-1-6. Each player draws 6 cards from their deck as their
      # opening hand.
      STARTING_HAND_COUNT.times do
        card = @game.draw_top_card_from_deck(@player)
        @game.add_card_to_hand(@player, card)
      end
    end

    unless @game.all_players_present?
      system_messages << {body: "Waiting for opponent to join..."}
    end

    if @game.all_players_present? && @game.status != STATUS_LIST[:STARTED]
      @game.first_turn = 1
      @game.status = STATUS_LIST[:STARTED]
      @game.requires_player_1_response = 1
      @game.requires_player_2_response = 1
      @game.auto_action = "start_mulligan_phase"
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def select_card(data)
    authorize!
    set_players

    system_messages = []
    player_messages = []
    opponent_messages = []

    card = data["card"]

    card_info = @game.get_card_info(card)
    card_state = @game.get_card_state(@player, card)

    if card_state.empty?
      card_state = @game.get_card_state(@opponent, card)
    end

    area = card_state[AREA]

    card_in_area = @game.card_is_in_area?(@player, area, card)
    selected_cards = @game.cards_selected(@player, area)

    case @game.phase
    when PHASE_LIST[:MULLIGAN_PHASE]
      if card_in_area
        player_messages << {body: "You deselected #{card_info["title"]}."}
        @game.player_actions = "mulligan"
        @game.remove_card_selected_in_area(@player, area, card)
      else
        player_messages << {body: "You selected #{card_info["title"]}."}
        @game.player_actions = "mulligan"
        @game.set_cards_selected_in_area(@player, area, card)
      end

    when PHASE_LIST[:CHARGE_PHASE]
      if card_in_area
        player_messages << {body: "You deselected #{card_info["title"]}."}
        @game.player_actions = "charge"
        @game.remove_card_selected_in_area(@player, area, card)
      else
        if selected_cards.length >= 1
          player_messages << {body: "You cannot select multiple cards."}
        else
          player_messages << {body: "You selected #{card_info["title"]}."}
          @game.player_actions = "charge"
          @game.set_cards_selected_in_area(@player, area, card)
        end
      end

    when PHASE_LIST[:MAIN_PHASE]
      if card_in_area
        player_messages << {body: "You deselected #{card_info["title"]}."}
        @game.clear_player_actions
        @game.remove_card_selected_in_area(@player, area, card)
      else
        if @game.step == "declare_play"
          if selected_cards.length >= 1
            player_messages << {body: "You cannot select multiple cards."}
          else
            player_messages << {body: "You selected #{card_info["title"]}."}
            @game.player_actions = "declare_play"
            @game.set_cards_selected_in_area(@player, area, card)
          end
        elsif @game.step == "pay_energy_cost"
          player_messages << {body: "You selected #{card_info["title"]}."}
          @game.player_actions = "pay_energy_cost"

          @game.set_cards_selected_in_area(@player, area, card)
        elsif @game.step == "select_attack_target"
          player_messages << {body: "You selected #{card_info["title"]}."}
          @game.target = card
          @game.set_cards_selected_in_area(@opponent, area, card)
        else
          if !@game.is_card_playable?(@player, card)
            player_messages << {body: "You cannot play this card."}
            @game.clear_player_actions
          elsif selected_cards.length >= 1
            player_messages << {body: "You cannot select multiple cards."}
          else
            player_messages << {body: "You selected #{card_info["title"]}."}
            if card_state[AREA] == AREA_LIST[:BATTLE_AREA]
              @game.player_actions = "declare_attack"
              @game.set_cards_selected_in_area(@player, area, card)
            else
              @game.player_actions = "declare_play"
              @game.set_cards_selected_in_area(@player, area, card)
            end
          end
        end
      end
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def draw_card
    authorize!
    set_players

    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "#{@player} drew a card."}

    card = @game.draw_top_card_from_deck(@player)
    @game.add_card_to_hand(@player, card)

    if @game.no_cards_in_deck?(@player)
      @game.auto_action = "game_over"
      system_messages << {body: "#{@player} has no cards left in deck."}
      player_messages << {body: "Defeat!"}
      opponent_messages << {body: "Victory!"}
    else
      if @game.callback_action.present?
        @game.auto_action = @game.callback_action.to_sym
        @game.callback_action = nil
      end
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def start_mulligan_phase
    authorize!
    set_players

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.set_cards_selectable(@player, @game.hand(@player))
    @game.phase = PHASE_LIST[:MULLIGAN_PHASE]
    @game.clear_auto_action
    @game.player_actions = "mulligan"
    @game.set_player_action_messages(@player, "You can redraw cards in your hand.|Pick the cards you want to replace.")

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def mulligan
    authorize!
    set_players

    system_messages = []
    player_messages = []
    opponent_messages = []

    hand_cards_selected = @game.cards_selected(@player, AREA_LIST[:HAND])

    # 5-2-1-6-1. A player may return any number of cards to their deck. They shuffle their deck,
    # then draw that many cards from their deck.
    hand_cards_selected.each do |card|
      @game.remove_card_from_hand(@player, card)
    end

    hand_cards_selected.each do |card|
      @game.add_card_to_deck_area(@player, card)
    end

    @game.shuffle_deck(@player)

    hand_cards_selected.length.times do
      card = @game.draw_top_card_from_deck(@player)
      @game.add_card_to_hand(@player, card)
    end

    # 5-2-1-7. Each player places the top 8 cards of their deck face-down in their Life Area.
    NUMBER_OF_LIFEPOINTS.times do
      card = @game.draw_top_card_from_deck(@player)
      @game.add_card_to_life_area(@player, card)
    end

    @game.clear_all_cards_selected(@player)
    @game.clear_cards_selectable(@player)
    @game.set_mulliganed(@player)

    # 5-2-1-8. The first player begins the game and starts their turn.
    if @game.all_players_mulliganed?
      system_messages << {body: "All players mulliganed."}
      @game.stop_player_response(@player)
      @game.stop_player_response(@opponent)
      @game.allow_player_response(@game.turn_player)
      @game.clear_action_messages
      @game.clear_step
      @game.auto_action = "start_turn"
      @game.clear_player_actions
    else
      if @game.player_1_mulliganed
        @game.set_player_action_messages("player_1", "Waiting for opponent...")
      end

      if @game.player_2_mulliganed
        @game.set_player_action_messages("player_2", "Waiting for opponent...")
      end
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def start_turn
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "It is now #{@game.turn_player}'s turn."}
    system_messages << {body: "All cards are switched to active."}

    @game.clear_step
    @game.clear_player_actions
    @game.clear_cards_selectable(@player)
    @game.clear_all_cards_selected(@player)

    # 6-2-1 is missing

    # 6-2-2. Players Switch all of their cards in the Leader Area, Battle
    # Area, Energy Area, and Unison Area which are in Rest Mode to Active Mode.
    @game.switch_all_cards_to_active(@player)

    # 6-2-3. The turn player draws 1 card from their deck. The player playing first
    # does not draw on their first turn.
    if @game.first_turn
      @game.auto_action = "start_charge_phase"
    else
      @game.auto_action = "draw_card"
      @game.callback_action = "start_charge_phase"
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def start_charge_phase
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "It is now the charge phase."}

    @game.set_cards_selectable(@player, @game.hand(@player))
    @game.set_player_action_messages(@player, "Select a card to use as energy from your hand.")
    @game.phase = PHASE_LIST[:CHARGE_PHASE]
    @game.player_actions = "charge"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  # 6-2-5. The turn player may place 1 card from their hand into the Energy Area.
  def charge
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    hand_card_selected = @game.cards_selected(@player, AREA_LIST[:HAND])[0]

    if (hand_card_selected.present?)
      # 6-2-6. A checkpoint occurs. When all necessary processing is carried out for this checkpoint, proceed to the Main Phase.
      card_info = @game.get_card_info(hand_card_selected)

      @game.remove_card_from_hand(@player, hand_card_selected)
      @game.add_card_to_energy_area(@player, hand_card_selected)
      @game.set_cards_playable_from_hand(@player)

      player_messages << {body: "You charged #{card_info["title"]}."}
      opponent_messages << {body: "#{@player} charged #{card_info["title"]}."}
    else
      player_messages << {body: "You did not charge a card."}
      opponent_messages << {body: "#{@player} did not charge a card."}
    end

    @game.clear_all_cards_selected(@player)
    @game.clear_cards_selectable(@player)
    @game.auto_action = "start_main_phase"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def start_main_phase
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.phase = PHASE_LIST[:MAIN_PHASE]
    @game.set_cards_playable_from_hand(@player)

    system_messages << {body: "It is now start of main phase."}

    # 6-3-1-1.The trigger condition “At the beginning of the Main Phase” occurs,
    # and then a checkpoint occurs.
    if @game.auto_triggers(@player, @opponent).length > 0
      system_messages << {body: "AUTO skills conditions met. Please select skill to activate."}
    else
      system_messages << {body: "No AUTO skills conditions met."}
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def declare_play
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    hand_card_selected = @game.cards_selected(@player, AREA_LIST[:HAND])[0]

    if hand_card_selected.present?
      card_info = @game.get_card_info(hand_card_selected)

      # 6-3-1-2-1-1 Players declare that they’re playing the card
      player_messages << {body: "You selected to play #{card_info["title"]}."}
      player_messages << {body: "Proceed to pay energy cost for #{card_info["title"]}."}

      @game.set_cards_selectable(@player, @game.energy_area(@player))
      @game.set_player_action_messages(@player, "Please select cards(s)")
      @game.player_actions = "pay_energy_cost|cancel"
      @game.step = "pay_energy_cost"
    else
      player_messages << {body: "You did not select a card."}
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def pay_energy_cost
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    energy_cards_selected = @game.cards_selected(@player, AREA_LIST[:ENERGY_AREA])
    hand_card_selected = @game.cards_selected(@player, AREA_LIST[:HAND])[0]

    card_info = @game.get_card_info(hand_card_selected)

    # 6-3-1-2-1-1 Players switch the amount of energy necessary to play the card to Rest Mode.
    # If they cannot switch the necessary energy to Rest Mode, they can’t declare that they’re
    # playing the card.

    if energy_cards_selected.length < card_info["energy"].to_i
      @game.set_player_action_messages(@player, "You did not pay the correct energy cost.")
      @game.player_actions = "pay_energy_cost|cancel"
      @game.step = "pay_energy_cost"
    else
      player_messages << {body: "You declared to PLAY for #{card_info["title"]}."}
      opponent_messages << {body: "#{@player} declared to PLAY #{card_info["title"]}."}
      system_messages << {body: "Waiting for #{@opponent} to counter-play."}

      energy_cards_selected.each do |card|
        @game.set_card_to_rested(@player, card)
      end

      # 6-3-1-2-1-2. A counter timing occurs. The non-turn player can activate [Counter: Play]
      # skills which fulfill the necessary conditions.
      @game.auto_action = "declare_counter_play"
      @game.clear_cards_selectable(@player)
      @game.switch_player_response(@player, @opponent)
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def declare_counter_play
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.set_cards_selectable(@player, @game.hand(@player))
    @game.set_player_action_messages(@player, "Select Cards to Counter")
    @game.player_actions = "no_counter_play"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def pay_counter_cost
  end

  def no_counter_play
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.auto_action = "play"
    @game.clear_cards_selectable(@player)
    @game.switch_player_response(@player, @opponent)

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def play
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    hand_card_selected = @game.cards_selected(@player, AREA_LIST[:HAND])[0]
    card_info = @game.get_card_info(hand_card_selected)

    player_messages << {body: "You successfully played #{card_info["title"]}."}
    opponent_messages << {body: "#{@player} successfully played #{card_info["title"]}."}

    hand_card_selected = @game.cards_selected(@player, AREA_LIST[:HAND])[0]
    @game.remove_card_from_hand(@player, hand_card_selected)
    @game.add_card_to_battle_area(@player, hand_card_selected)
    @game.set_cards_playable_from_hand(@player)
    @game.clear_cards_selectable(@player)
    @game.clear_all_cards_selected(@player)

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def declare_attack
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    if @game.first_turn
      player_messages << {body: "You cannot attack on the first turn."}
      @game.clear_all_cards_selected(@player)
    else
      battle_area_card_selected = @game.cards_selected(@player, AREA_LIST[:BATTLE_AREA])[0]

      if battle_area_card_selected.present?
        @game.step = "select_attack_target"
        @game.attacker = battle_area_card_selected
        @game.clear_all_cards_selected(@player)

        card_info = @game.get_card_info(@game.attacker)
        player_messages << {body: "You selected #{card_info["title"]} to battle."}
        player_messages << {body: "Please select a target."}

        @game.set_cards_selectable(@player, @game.attackable_targets(@opponent))
        @game.set_player_action_messages(@player, "Please select a target.")
        @game.set_card_to_rested(@player, @game.attacker)
        @game.player_actions = "battle|cancel"
      else
        player_messages << {body: "You did not select a battle area or leader card."}
      end
    end

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def battle
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.auto_action = "start_battle_phase"
    @game.switch_player_response(@player, @opponent)
    @game.clear_cards_selectable(@player)
    @game.clear_all_cards_selected(@player)
    @game.clear_all_cards_selected(@opponent)

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def start_battle_phase
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "Waiting for #{@opponent} to counter-attack."}

    @game.set_cards_selectable(@player, @game.hand(@player))
    @game.set_player_action_messages(@player, "Select Cards to Counter")
    @game.player_actions = "no_counter_attack"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })

  end

  def no_counter_attack
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    # @game.auto_action = "attack"
    @game.clear_cards_selectable(@player)
    @game.switch_player_response(@player, @opponent)

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def attack
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    attacker_card_info = @game.get_card_info(@game.attacker)
    target_card_info = @game.get_card_info(@game.target)

    if @game.attack_success?(attacker_card_info, target_card_info)
      player_messages << {body: "You succeeded in attacking #{target_card_info["title"]}"}
      opponent_messages << {body: "#{@player} succeeded in attacking #{target_card_info["title"]}"}

      if target_card_info["type"] == CARD_TYPES[:LEADER]
        system_messages << {body: "#{@opponent}'s life took a hit!"}
        system_messages << {body: "#{@opponent} drew a random card from life area."}

        card = @game.draw_top_card_from_life_area(@opponent)
        @game.add_card_to_hand(@opponent, card)
      else
        @game.remove_card_from_battle_area(@opponent, @game.target)
        @game.add_card_to_drop_area(@opponent, @game.target)
      end
    else
      player_messages << {body: "You failed in attacking #{target_card_info["title"]}"}
      opponent_messages << {body: "#{@player} failed in attacking #{target_card_info["title"]}"}
    end

    system_messages << {body: "Battle ended."}

    @game.clear_all_cards_selected(@player)
    @game.attacker = nil
    @game.target = nil
    @game.auto_action = "start_main_phase"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def end_turn
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "#{@player} ended turn."}

    @game.phase = PHASE_LIST[:END_PHASE]
    @game.first_turn = 0
    @game.turn_player = @opponent
    @game.switch_player_response(@player, @opponent)
    @game.clear_cards_selectable(@player)
    @game.clear_all_cards_selected(@player)
    @game.auto_action = "start_turn"

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def cancel
    authorize!
    set_players
    reset_actions

    system_messages = []
    player_messages = []
    opponent_messages = []

    @game.clear_cards_selectable(@player)
    @game.clear_all_cards_selected(@player)

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  def game_over
    system_messages = []
    player_messages = []
    opponent_messages = []

    system_messages << {body: "Game over."}
    @game.requires_player_1_response = 0
    @game.requires_player_2_response = 0

    broadcast_state({
                      system_messages: system_messages,
                      player_messages: player_messages,
                      opponent_messages: opponent_messages
                    })
  end

  private

  def authorize!
    raise ERRORS[:UNAUTHORIZED] unless @game.can_respond?(@player)
  end

  def user_id
    JWT.decode(params["token"], "secret", false)[0]["id"]
  end

  def set_players
    if @game.player_1.present? && @game.player_1 != @user.username
      @player = PLAYER_2
      @opponent = PLAYER_1
      @game.player_2 = @user.username
      @all_players = [@game.player_2, @game.player_1]
    else
      @player = PLAYER_1
      @opponent = PLAYER_2
      @game.player_1 = @user.username
      @all_players = [@game.player_1, @game.player_2]
    end
  end

  def deck_cards
    @deck.main_deck_cards.reduce([]) do |acc, object|
      acc << object[1].times.map do |_n|
        id = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
        object[0] + "__#{id}"
      end
    end.flatten.shuffle
  end

  def deck_leader
    id = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
    "#{@deck.leader_number}__#{id}"
  end

  def reset_actions
    @game.clear_auto_action
    @game.clear_action_messages
    @game.clear_player_actions
    @game.clear_step
  end

  def broadcast_state(data)
    puts "********** Broadcast to Game #{@game_id} **********"
    ActionCable.server.broadcast("game_#{@game_id}", {
      game_state: @game.state.to_h,
      messages: data[:system_messages].map { |message| message.merge({type: "system"}) }
    })

    puts "************ Broadcast to #{@player} ************"
    ActionCable.server.broadcast("user_#{@all_players[0]}", {
      private_player_state: @game.private_player_state(@player, @opponent),
      public_player_state: @game.public_player_state(@player),
      public_opponent_state: @game.public_player_state(@opponent),
      messages: data[:player_messages].map { |message| message.merge({type: PLAYER}) }
    })

    puts "************ Broadcast to #{@opponent} ************"
    ActionCable.server.broadcast("user_#{@all_players[1]}", {
      private_player_state: {hand: @game.hand(@opponent)},
      public_player_state: @game.public_player_state(@opponent),
      public_opponent_state: @game.public_player_state(@player),
      messages: data[:opponent_messages].map { |message| message.merge({type: OPPONENT}) }
    })
  end
end
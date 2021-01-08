module DBSCG
  class Game
    attr_accessor :id

    def initialize(id)
      @id = id
    end

    # class methods
    def self.create(id)
      REDIS.hset("game:#{id}", *STARTING_STATE)
    end

    def self.find(id)
      REDIS.hgetall("game:#{id}")
      new(id)
    end

    # instance methods
    def state
      Redix::Game.hgetall(self)
    end

    #getter
    ATTRIBUTES.each do |attribute|
      field = attribute[0]
      format = attribute[1]
      bool = attribute[2]
      define_method(field) do
        res = self.state.public_send(field).public_send(format)
        res = res.public_send(bool) if bool
        res
      end
    end

    #setter
    ATTRIBUTES.each do |attribute|
      field = attribute[0]

      define_method("#{field}=") do |val|
        Redix::Game.hset(self, field, val)
      end

      define_method("clear_#{field}") do
        Redix::Game.hset(self, field, "")
      end
    end

    ##########################################
    ############ START AREA CARDS ############
    ##########################################
    def battle_area(player)
      Redix::BattleArea.zrange(self, player)
    end

    def deck_area(player)
      Redix::Deck.lrange(self, player)
    end

    def combo_area(player)
      Redix::ComboArea.zrange(self, player)
    end

    def drop_area(player)
      Redix::DropArea.zrange(self, player)
    end

    def energy_area(player)
      Redix::EnergyArea.zrange(self, player)
    end

    def hand(player)
      Redix::Hand.zrange(self, player)
    end

    def leader_area(player)
      Redix::LeaderArea.zrange(self, player)
    end

    def life_area(player)
      Redix::LifeArea.zrange(self, player)
    end
    ##########################################
    ############# END AREA CARDS #############
    ##########################################


    ##########################################
    ########## START DRAW TOP CARD ###########
    ##########################################
    def draw_top_card_from_deck(player)
      Redix::Deck.lpop(self, player)
    end

    def draw_top_card_from_life_area(player)
      Redix::LifeArea.zpopmin(self, player)[0]
    end
    ##########################################
    ########### END DRAW TOP CARD ############
    ##########################################


    ##########################################
    ######### START ADD CARD TO AREA #########
    ##########################################
    def add_card_to_battle_area(player, card)
      Redix::BattleArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:BATTLE_AREA]])
    end

    def add_card_to_combo_area(player, card)
      Redix::ComboArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:COMBO_AREA]])
    end

    def add_card_to_deck_area(player, card)
      Redix::Deck.rpush(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:DECK_AREA]])
    end

    def add_card_to_drop_area(player, card)
      Redix::DropArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:DROP_AREA]])
    end

    def add_card_to_energy_area(player, card)
      Redix::EnergyArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:ENERGY_AREA]])
    end

    def add_card_to_hand(player, card)
      Redix::Hand.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE], AREA, AREA_LIST[:HAND]])
    end

    def add_card_to_leader_area(player, card)
      Redix::LeaderArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE]], AREA, AREA_LIST[:LEADER_AREA])
    end

    def add_card_to_life_area(player, card)
      Redix::LifeArea.zadd(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [ID, card, MODE, MODE_LIST[:ACTIVE]], AREA, AREA_LIST[:LIFE_AREA])
    end
    ##########################################
    ########## END ADD CARD TO AREA ##########
    ##########################################

    ##########################################
    ###### START DISCARD CARD FROM AREA ######
    ##########################################
    def remove_card_from_hand(player, card)
      Redix::Hand.zrem(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [AREA, nil])
    end

    def remove_card_from_battle_area(player, card)
      Redix::BattleArea.zrem(self, player, card)
      Redix::PlayerCard.hset(self, player, card, [AREA, nil])
    end
    ##########################################
    ####### END DISCARD CARD FROM AREA #######
    ##########################################

    #################################################
    ####### START SET CARD TO ACTIVE/RESTED #########
    #################################################
    def set_card_to_active(player, card)
      Redix::PlayerCard.hset(self, player, card, [MODE, MODE_LIST[:ACTIVE]])
    end

    def set_card_to_rested(player, card)
      Redix::PlayerCard.hset(self, player, card, [MODE, MODE_LIST[:RESTED]])
    end
    ################################################
    ######### END SET CARD TO ACTIVE/RESTED ########
    ################################################


    ##########################################
    ########## START SELECTED CARDS ##########
    ##########################################
    def card_is_in_area?(player, area, card)
      Redix::CardsSelected.zrank(self, player, area, card) != nil
    end

    def cards_selected(player, area)
      Redix::CardsSelected.zrange(self, player, area)
    end

    def clear_cards_selected_in_area(player, area)
      Redix::CardsSelected.del(self, player, area)
    end

    def set_cards_selected_in_area(player, area, card)
      Redix::CardsSelected.zadd(self, player, area, card)
    end

    def remove_card_selected_in_area(player, area, card)
      Redix::CardsSelected.zrem(self, player, area, card)
    end

    def clear_all_cards_selected(player)
      clear_cards_selected_in_area(player, AREA_LIST[:BATTLE_AREA])
      clear_cards_selected_in_area(player, AREA_LIST[:HAND])
      clear_cards_selected_in_area(player, AREA_LIST[:ENERGY_AREA])
    end
    ##########################################
    ########### END SELECTED CARDS ###########
    ##########################################


    ##########################################
    ######### START SELECTABLE CARDS #########
    ##########################################
    def set_cards_selectable(player, cards)
      attrs = cards.map.with_index do |card, index|
        rank = index + 1
        [rank, card[ID]]
      end.flatten

      Redix::CardsSelectable.zadd(self, player, attrs)
    end

    def cards_selectable(player)
      Redix::CardsSelectable.zrange(self, player)
    end

    def clear_cards_selectable(player)
      Redix::CardsSelectable.del(self, player)
    end
    ##########################################
    ########## END SELECTABLE CARDS ##########
    ##########################################


    ##########################################
    ########## START PLAYABLE CARDS ##########
    ##########################################
    def cards_playable(player)
      Redix::CardsPlayable.zrange(self, player)
    end

    def add_to_cards_playable(player, card)
      Redix::CardsPlayable.zadd(self, player, card)
    end

    def remove_from_cards_playable(player, card)
      Redix::CardsPlayable.zrem(self, player, card)
    end

    def is_card_playable?(player, card)
      cards_playable(player).include?(card)
    end
    ##########################################
    ########### END PLAYABLE CARDS ###########
    ##########################################


    def get_card_info(card)
      card_id = card.split("__")[0]
      Redix::CardInfo.hgetall(card_id)
    end

    def get_card_state(player, card)
      Redix::PlayerCard.hgetall(self, player, card)
    end

    def shuffle_deck(player)
      cards = deck_area(player)
      Redix::Deck.del(self, player)
      set_deck(player, cards.shuffle)
    end

    def set_deck(player, cards)
      Redix::Deck.rpush(self, player, cards)
    end

    def set_deck_leader(player, leader)
      Redix::Deck.rpush(self, player, leader)
    end

    def set_cards_playable_from_hand(player)
      player_hand = hand(player).filter do |card|
        hand_card_info = get_card_info(card[ID])
        hand_card_info[TYPE] == TYPE_LIST[:BATTLE]
      end

      player_energy_area = energy_area(player).filter do |card|
        card[MODE] == MODE_LIST[:ACTIVE]
      end

      player_hand.each do |card|
        card_id = card[ID]
        card_info = get_card_info(card_id)
        specified_energy = card_info["specified_energy"].split("|")

        player_energy_area_colors =
          player_energy_area.collect do |card|
            energy_card_id = card[ID]
            energy_card_info = get_card_info(energy_card_id)
            energy_card_info[COLOR].downcase
          end

        specified_energy_conditions_met =
          specified_energy.map do |color|
            if player_energy_area_colors.include?(color)
              index = player_energy_area_colors.find_index { |c| c == color }
              player_energy_area_colors.delete_at(index)
              true
            else
              false
            end
          end.all? { |res| res == true }

        if player_energy_area.length >= card_info[ENERGY].to_i && specified_energy_conditions_met
          add_to_cards_playable(player, card_id)
        else
          remove_from_cards_playable(player, card_id)
        end
      end
    end


    def set_mulliganed(player)
      self.public_send("#{player}_mulliganed=", 1)
    end

    def set_player_action_messages(player, messages)
      self.public_send("#{player}_action_messages=", messages)
    end

    def clear_action_messages
      self.player_1_action_messages = ""
      self.player_2_action_messages = ""
    end

    def all_players_mulliganed?
      player_1_mulliganed && player_2_mulliganed
    end

    def all_players_present?
      [player_1, player_2].all? { |attr| attr.present? }
    end

    def is_missing_player?
      !all_players_present?
    end

    def switch_all_cards_to_active(player)
      leader_area(player).each do |card|
        set_card_to_active(player, card[ID])
      end

      energy_area(player).each do |card|
        set_card_to_active(player, card[ID])
      end

      battle_area(player).each do |card|
        set_card_to_active(player, card[ID])
      end
    end

    def player_messages(player)
      self.public_send("#{player}_action_messages")
    end

    def switch_player_response(player, opponent)
      self.public_send("requires_#{player}_response=", 0)
      self.public_send("requires_#{opponent}_response=", 1)
    end

    def can_respond?(player)
      self.public_send("requires_#{player}_response")
    end

    def allow_player_response(player)
      self.public_send("requires_#{player}_response=", 1)
    end

    def stop_player_response(player)
      self.public_send("requires_#{player}_response=", 0)
    end

    def attack_success?(attacker, target)
      attacker[POWER].to_i >= target[POWER].to_i
    end

    def no_cards_in_deck?(player)
      deck_area(player).length <= 0
    end

    def auto_triggers(player, opponent)
      []
    end

    def attackable_targets(player)
      active_battle_area = battle_area(player).filter do |card|
        card[MODE] == MODE_LIST[:RESTED]
      end

      leader_area = leader_area(player)

      leader_area.concat(active_battle_area)
    end

    def private_player_state(player, opponent)
      {
        player: player,
        hand: hand(player),
        hand_cards_selected: cards_selected(player, AREA_LIST[:HAND]),
        battle_area_cards_selected: cards_selected(player, AREA_LIST[:BATTLE_AREA]).concat(cards_selected(opponent, AREA_LIST[:BATTLE_AREA])),
        energy_area_cards_selected: cards_selected(player, AREA_LIST[:ENERGY_AREA]),
        cards_selectable: cards_selectable(player),
        cards_playable: cards_playable(player),
      }
    end

    def public_player_state(player)
      {
        hand: hand(player).map { "" },
        deck_area: deck_area(player).map { "" },
        battle_area: battle_area(player),
        drop_area: drop_area(player),
        energy_area: energy_area(player).reverse,
        leader_area: leader_area(player),
        life_area: life_area(player).map { "" }
      }
    end
  end
end

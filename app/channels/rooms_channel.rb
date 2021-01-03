class RoomsChannel < ApplicationCable::Channel
  # when a user is 'subscribed' it means that they have loaded the relevant page and are viewing it

  def subscribed
    @room = Room.find(params[:room])

    stream_for @room
  end

  def join(data)
    user_id = JWT.decode(data["token"], "secret", false)[0]["id"]
    user = User.find(user_id)

    if @room.player_1.present? && @room.player_1 != user
      @player     = "player_2"
      @opponent = "player_1"
      @room.player_2 = user
    else
      @player          = "player_1"
      @opponent      = "player_2"
      @room.player_1 = user
    end

    update_game_state

    broadcast_to_room({ messages: [
                          construct_broadcast_message("#{user.username} has joined the game")
                        ],
                        gameState: @room.game_state
                      })

    can_select_deck = player.present? && opponent.present?
    if can_select_deck
      if self_deck.blank?
        send_to_self(
          {
            messages: [
              construct_player_message("Please select a deck")
            ],
            playerState: {
              decks: player.decks.not_draft
            }
          }
        )
      end

      if opponent_deck.blank?
        send_to_opponent(
          {
            messages: [
              construct_player_message("Please select a deck")
            ],
            playerState: {
              decks: opponent.decks.not_draft
            }
          }
        )
      end
    end

    can_load_deck = self_deck.present? && opponent_deck.present?
    if can_load_deck
      send_to_self(
        {
          messages: [],
          playerState: {
            selectedDeck: self_deck
          }
        }
      )
    end
  end

  def deck_select(data)
    deck_id = data["deck_id"]
    set_self_deck(Deck.find(deck_id))

    send_to_self(
      {
        messages: [
          construct_player_message("You have selected a deck")
        ],
        gameState: {}
      }
    )

    update_game_state
    can_start_game = self_deck.present? && opponent_deck.present?
    if can_start_game
      broadcast_to_room(
        {
          messages: [
            construct_broadcast_message("Both players have selected their decks"),
            construct_broadcast_message("Initializing deck")
          ],
          gameState: @room.game_state
        }
      )
    end

  end

  def load_decks
    send_to_self(
      {
        messages: [],
        gameState: {},
        playerState: {
          selectedDeck: self_deck
        }
      }
    )

    send_to_opponent(
      {
        messages: [],
        gameState: {},
        playerState: {
          selectedDeck: opponent_deck
        }
      }
    )
  end

  def unsubscribed
    # any cleanup needed when channel is unsubscribed
  end


  private
  def player
    @room.public_send(@player)
  end

  def opponent
    @room.public_send(@opponent)
  end

  def set_self_deck(deck)
    @room.public_send("#{@player}_deck=", deck)
    @room.save
    @room.reload
  end

  def self_deck
    @room.public_send("#{@player}_deck")
  end

  def opponent_deck
    @room.public_send("#{@opponent}_deck")
  end

  def broadcast_to_room(message)
    RoomsChannel.broadcast_to(@room, message)
  end

  def send_to_self(message)
    UsersChannel.broadcast_to(player, message)
  end

  def send_to_opponent(message)
    UsersChannel.broadcast_to(opponent, message)
  end

  def construct_player_message(body)
    {
      type: "player",
      timestamp: Time.now,
      body: body
    }
  end

  def construct_broadcast_message(body)
    {
      type: "broadcast",
      timestamp: Time.now,
      body: body
    }
  end

  def update_game_state
    can_select_deck = player.present? && opponent.present?
    can_start_game = self_deck.present? && opponent_deck.present?


    puts "can_start_game: #{can_start_game}"
    puts self_deck.inspect
    puts opponent_deck.inspect

    @room.game_state = @room.game_state.merge({
      canSelectDeck: can_select_deck,
      canStartGame: can_start_game,
      gameStarted: @room.status === "STARTED"
    })

    @room.save
    @room.reload
  end
end
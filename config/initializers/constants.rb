PLAYER_1                   = "player_1"
PLAYER_2                   = "player_2"
PLAYER_1_DECK_ID           = "player_1_deck_id"
PLAYER_2_DECK_ID           = "player_2_deck_id"
PLAYER_1_MULLIGANED        = "player_1_mulliganed"
PLAYER_2_MULLIGANED        = "player_2_mulliganed"
REQUIRES_PLAYER_1_RESPONSE = "requires_player_1_response"
REQUIRES_PLAYER_2_RESPONSE = "requires_player_2_response"
PLAYER_1_ACTION_MESSAGES   = "player_1_action_messages"
PLAYER_2_ACTION_MESSAGES   = "player_2_action_messages"
STATUS                     = "status"
TURN_PLAYER                = "turn_player"
TURN                       = "turn"
PHASE                      = "phase"
ID                         = "id"
COLOR                      = "color"
POWER                      = "power"
ENERGY                     = "energy"
TYPE                       = "type"
STARTING_HAND_COUNT        = 6
NUMBER_OF_LIFEPOINTS       = 8
MODE                       = "mode"
STEP                       = "step"
AREA                       = "area"
FIRST_TURN                 = "first_turn"
PLAYER                     = "player"
OPPONENT                   = "opponent"
ATTACKER                   = "attacker"
TARGET                     = "target"
CALLBACK_ACTION            = "callback_action"
AUTO_ACTION                = "auto_action"
PLAYER_ACTIONS             = "player_actions"
TYPE_LIST                  = { LEADER: "LEADER", BATTLE: "BATTLE", EXTRA: "EXTRA"}
MODE_LIST                  = { ACTIVE: "ACTIVE", RESTED: "RESTED" }
STATUS_LIST                = { NOT_STARTED: "NOT_STARTED", STARTED: "STARTED", ENDED: "ENDED" }
PHASE_LIST                 = { MULLIGAN_PHASE: "Mulligan Phase", CHARGE_PHASE: "Charge Phase", MAIN_PHASE: "Main Phase", BATTLE_PHASE: "Battle Phase", END_PHASE: "End Phase" }
AREA_LIST                  = { DECK_AREA: "deck_area", DROP_AREA: "drop_area", LIFE_AREA: "life_area", HAND: "hand", ENERGY_AREA: "energy_area", BATTLE_AREA: "battle_area", COMBO_AREA: "combo_area", LEADER_AREA: "leader_area" }
ERRORS                     = { NOT_ALLOWED: "NOT_ALLOWED", UNAUTHORIZED: "UNAUTHORIZED" }
ATTACKABLE_CARD_TYPES      = ["BATTLE", "UNISON", "LEADER"]
CARD_TYPES                 = { BATTLE: "BATTLE", LEADER: "LEADER", UNISON: "UNISON", EXTRA: "EXTRA" }
ACTION_TYPES               = { MANUAL: "MANUAL", AUTO: "AUTO" }


STARTING_STATE = [
    PLAYER_1, nil,
    PLAYER_1_DECK_ID, nil,
    PLAYER_1_MULLIGANED, nil,
    PLAYER_2, nil,
    PLAYER_2_MULLIGANED, nil,
    PLAYER_2_DECK_ID, nil,
    STATUS, STATUS_LIST[:NOT_STARTED],
    TURN_PLAYER, nil,
    PHASE, nil,
    FIRST_TURN, nil,
    STEP, nil
]

ATTRIBUTES = [
    [STATUS, :to_s],
    [TURN_PLAYER, :to_s],
    [PLAYER_1, :to_s],
    [PLAYER_2, :to_s],
    [PHASE, :to_s],
    [STEP, :to_s],
    [ATTACKER, :to_s],
    [TARGET, :to_s],
    [CALLBACK_ACTION, :to_s],
    [AUTO_ACTION, :to_s],
    [FIRST_TURN, :to_i, :odd?],
    [PLAYER_1_MULLIGANED, :to_i, :odd?],
    [REQUIRES_PLAYER_1_RESPONSE, :to_i, :odd?],
    [PLAYER_2_MULLIGANED, :to_i, :odd?],
    [REQUIRES_PLAYER_2_RESPONSE, :to_i, :odd?],
    [PLAYER_ACTIONS, :to_s],
    [PLAYER_1_ACTION_MESSAGES, :to_s],
    [PLAYER_2_ACTION_MESSAGES, :to_s]
]
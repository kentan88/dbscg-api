# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_30_124033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "title", null: false
    t.string "title_back"
    t.string "number", null: false
    t.string "series"
    t.string "rarity", null: false
    t.string "type", null: false
    t.string "color"
    t.integer "energy"
    t.text "energy_text"
    t.integer "combo_energy"
    t.integer "combo_power"
    t.integer "power"
    t.integer "power_back"
    t.string "character"
    t.string "special_trait"
    t.string "era"
    t.string "skills", default: [], array: true
    t.text "skills_text"
    t.string "skills_back", default: [], array: true
    t.text "skills_back_text"
    t.float "rating", default: 0.0
    t.index ["character"], name: "index_cards_on_character"
    t.index ["color"], name: "index_cards_on_color"
    t.index ["combo_energy"], name: "index_cards_on_combo_energy"
    t.index ["combo_power"], name: "index_cards_on_combo_power"
    t.index ["energy"], name: "index_cards_on_energy"
    t.index ["era"], name: "index_cards_on_era"
    t.index ["number"], name: "index_cards_on_number"
    t.index ["power"], name: "index_cards_on_power"
    t.index ["power_back"], name: "index_cards_on_power_back"
    t.index ["rarity"], name: "index_cards_on_rarity"
    t.index ["rating"], name: "index_cards_on_rating"
    t.index ["series"], name: "index_cards_on_series"
    t.index ["skills_back_text"], name: "index_cards_on_skills_back_text"
    t.index ["skills_text"], name: "index_cards_on_skills_text"
    t.index ["special_trait"], name: "index_cards_on_special_trait"
    t.index ["title"], name: "index_cards_on_title"
    t.index ["title_back"], name: "index_cards_on_title_back"
    t.index ["type"], name: "index_cards_on_type"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.bigint "card_id", null: false
    t.integer "quantity"
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.bigint "card_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "private", default: false
    t.index ["card_id"], name: "index_decks_on_card_id"
    t.index ["private"], name: "index_decks_on_private"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "leaders", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.string "title"
    t.string "title_back"
    t.integer "power"
    t.integer "power_back"
    t.string "number"
    t.text "stats", default: "{}"
    t.text "jsonb", default: "{}"
    t.string "card_number"
    t.index ["card_id"], name: "index_leaders_on_card_id"
    t.index ["card_number"], name: "index_leaders_on_card_number"
    t.index ["number"], name: "index_leaders_on_number"
    t.index ["title"], name: "index_leaders_on_title"
    t.index ["title_back"], name: "index_leaders_on_title_back"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "deck_cards", "cards"
  add_foreign_key "deck_cards", "decks"
  add_foreign_key "decks", "cards"
  add_foreign_key "decks", "users"
end

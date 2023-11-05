# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_05_102044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_match_turns", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "turn_number", default: 1, null: false
    t.integer "player_color", default: 0, null: false
    t.jsonb "move"
    t.jsonb "boards", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["match_id"], name: "index_game_match_turns_on_match_id"
  end

  create_table "game_matches", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "ruleset", default: 0, null: false
    t.bigint "black_player_id"
    t.bigint "white_player_id"
    t.integer "state", default: 0, null: false
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.bigint "winner_id"
    t.index ["black_player_id"], name: "index_game_matches_on_black_player_id"
    t.index ["white_player_id"], name: "index_game_matches_on_white_player_id"
    t.index ["winner_id"], name: "index_game_matches_on_winner_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.bigint "user_id"
    t.string "displaying_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid"
    t.index ["user_id"], name: "index_game_players_on_user_id", unique: true
    t.index ["uuid"], name: "index_game_players_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_players", "users"
end
